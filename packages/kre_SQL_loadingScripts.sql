--script for generating dim_dates
declare
	@StartDate date = convert(datetime, '1900.01.01', 102)
,	@EndDate date = convert(datetime, '2099.12.31', 102)
,	@DateCounter int = 0;

set IDENTITY_INSERT dim_dates ON;
while (@StartDate <= @EndDate)
begin
	insert into dim_dates(
			dates_sk
		,	dates_nk
		,	dates_year
		,	dates_month
		,	dates_day
		,	dates_quarter
		,	dates_year_quarter) 
	values(
			cast(FORMAT( @StartDate, 'yyyyMMdd') as int)		
		,	@StartDate
		,	cast(FORMAT( @StartDate, 'yyyy') as varchar)
		,	cast(FORMAT( @StartDate, 'MM') as varchar)
		,	cast(FORMAT( @StartDate, 'dd') as varchar)
		,	'Q'+ cast(DATEPART(QUARTER, @StartDate)	as varchar)
		,	cast(FORMAT( @StartDate, 'yyyy') as varchar) + '.Q'+ cast(DATEPART(QUARTER, @StartDate)	as varchar)
	)
	set @DateCounter += 1;
	set @StartDate = dateadd(day,1,@StartDate);
end;
--end of script


--script for generating response type to dim_response_type
begin
	insert into dim_response_type(
			response_type_nk
		,	response_type_description)
	values 
			('A', 'Claim accepted by authorities')
		,	('R', 'Claim rejected by authorities')
		,	('P', 'Claim status pending');
end;
--end of script

--script for inserting DrugProducts and DrugProductFamily into dim_product
declare
	@MinDate				date = convert(datetime, '1800.01.01', 102)
,	@MaxDate				date = convert(datetime, '9999.12.31', 102)
,	@DrugProductId			char(13)
,	@DrugProductName		varchar(250)
,	@DrugProductFamilyName	varchar(250)
,	@ProductCursor			CURSOR
,	@Counter				INT = 0
;

set @ProductCursor = CURSOR FOR 
	select 
			dp.DrugProductId
		,	dp.DrugProductName
		,	dpf.DrugProductFamilyName
	from
		DrugProduct dp
		left outer join DrugProductFamily dpf
		on dpf.DrugProductFamilyId = dp.DrugProductFamilyId
	where 
			1=1
		and	dp.DrugProductFamilyId is not null
	;

open @ProductCursor;
fetch next from @ProductCursor into @DrugProductId, @DrugProductName, @DrugProductFamilyName;

while @@FETCH_STATUS = 0
	begin
		--here SCD2 logic can be applied - SQL merge can be used to speed up the process
		insert into dim_product(
				product_nk
			,	product_description
			,	product_family_description
			,	product_date_from
			,	product_date_to
			,	product_is_current
		)
		values(
				@DrugProductId
			,	@DrugProductName
			,	@DrugProductFamilyName
			,	@MinDate
			,	@MaxDate
			,	'Y'
		);

		fetch next from @ProductCursor into @DrugProductId, @DrugProductName, @DrugProductFamilyName;
		set @Counter += 1;
	end;

close @ProductCursor;
deallocate @ProductCursor;

print cast(@Counter as varchar(1000));

-- end of script