/*
drop table fact_product_registration;
drop table fact_product_reimbursement;
drop table dim_dates;
drop table dim_product;
drop table dim_product_family;
drop table dim_factory;
drop table dim_country;
drop table dim_indication;
drop table dim_response_type;
*/

create table dim_dates (
    dates_sk int identity(1,1)
  , dates_nk date
  , dates_year VARCHAR(4)
  ,	dates_month VARCHAR(2)
  ,	dates_day VARCHAR(2)
  , dates_quarter VARCHAR(2)
  , dates_year_quarter VARCHAR(7)
  , constraint pk_dim_dates primary key (dates_sk)
);


create table dim_product (
	product_sk int identity(1,1)
  , product_nk char(13)
  , product_description varchar(250)
  ,	product_family_description varchar(250)
  ,	product_date_from date
  ,	product_date_to date
  ,	product_is_current char(1)
  , constraint pk_dim_product primary key (product_sk)
);

create table dim_country(
	country_sk int identity(1,1)
  , country_nk char(2)
  , country_eng_name varchar(200)
  , country_nk3 char(3)
  , constraint pk_dim_country primary key (country_sk)
);

create table dim_factory(
	factory_sk int identity(1,1)
  , factory_nk char(4)
  , factory_name varchar(200)
  , factory_country_eng_name varchar(200)
  , factory_date_from date
  , factory_date_to date
  , factory_is_current char(1)
  , constraint pk_dim_facotry primary key (factory_sk)
);

create table dim_indication(
	  indication_sk int identity(1,1)
    , indication_nk char(13)
    , indication_description varchar(500)
	, indication_date_from date
	, indication_date_to date
	, indication_is_current char(1)
    , constraint pk_dim_indication primary key (indication_sk)
);

create table dim_response_type (
	response_type_sk int identity(1,1)
  , response_type_nk char(1)
  , response_type_description varchar(50)
  , constraint pk_dim_response_type_id primary key (response_type_sk)
);

create table fact_product_registration (
      claim_number varchar(20)
    , claim_submission_date_sk int
    , claim_expected_response_date_sk int
    , claim_response_date_sk int
    , claim_response_type_sk int
    , claim_product_sk int
	, claim_submission_country_sk int
    , claim_inditaction_sk int
    , claim_factory_api_sk int
    , claim_factory_bulk_sk int
    , claim_factory_package_sk int
	, claim_unity int not null default 1
    , constraint pk_fakt_drug_registration primary key (	claim_number
                                                        ,	claim_submission_date_sk
                                                        ,	claim_expected_response_date_sk
                                                        ,	claim_response_date_sk
                                                        ,	claim_response_type_sk
                                                        ,	claim_product_sk
														,	claim_submission_country_sk
														,	claim_inditaction_sk
                                                        ,	claim_factory_api_sk
                                                        ,	claim_factory_bulk_sk
                                                        ,	claim_factory_package_sk)
    , constraint fk_reg_claim_submission_date_sk foreign key (claim_submission_date_sk) references dim_dates(dates_sk)
    , constraint fk_reg_claim_exp_resp_date_sk foreign key (claim_expected_response_date_sk) references dim_dates(dates_sk)
    , constraint fk_reg_claim_response_date_sk foreign key (claim_response_date_sk) references dim_dates(dates_sk)
    , constraint fk_reg_claim_response_type_ak foreign key (claim_response_type_sk) references dim_response_type(response_type_sk)
    , constraint fk_reg_claim_product_sk foreign key (claim_product_sk) references dim_product(product_sk)
	, constraint fk_reg_claim_submis_country_sk foreign key (claim_submission_country_sk) references dim_country(country_sk)
	, constraint fk_reg_claim_indication_sk foreign key (claim_inditaction_sk) references dim_indication(indication_sk)
    , constraint fk_reg_claim_factory_api_sk foreign key (claim_factory_api_sk) references dim_factory(factory_sk)
    , constraint fk_reg_claim_factory_bulk_sk foreign key (claim_factory_bulk_sk) references dim_factory(factory_sk)
    , constraint fk_reg_claim_factory_pack_sk foreign key (claim_factory_package_sk) references dim_factory(factory_sk) 
);


create table fact_product_reimbursement (
      claim_number varchar(20)
    , claim_submission_date_sk int
    , claim_expected_response_date_sk int
    , claim_response_date_sk int
    , claim_response_type_sk int
    , claim_product_sk int
    , claim_submission_country_sk int
    , claim_inditaction_sk int
    , claim_drug_price money
    , claim_drug_reimburse_rate int
    , claim_drug_reimburse_val int
    , constraint pk_fact_drug_reimbursement primary key (   claim_number
                                                          , claim_submission_date_sk
                                                          , claim_expected_response_date_sk
                                                          , claim_response_date_sk
                                                          , claim_response_type_sk
                                                          , claim_product_sk
                                                          , claim_submission_country_sk
                                                          , claim_inditaction_sk)
    , constraint fk_rei_claim_submission_date_sk foreign key (claim_submission_date_sk) references dim_dates(dates_sk)
    , constraint fk_rei_claim_exp_resp_date_sk foreign key (claim_expected_response_date_sk) references dim_dates(dates_sk)
    , constraint fk_rei_claim_response_date_sk foreign key (claim_response_date_sk) references dim_dates(dates_sk)
    , constraint fk_rei_claim_response_type_sk foreign key (claim_response_type_sk) references dim_response_type(response_type_sk)
    , constraint fk_rei_claim_product_sk foreign key (claim_product_sk) references dim_product(product_sk)
    , constraint fk_rei_claim_sub_country_sk foreign key (claim_submission_country_sk) references dim_country(country_sk)
    , constraint fk_rei_claim_indication_sk foreign key (claim_inditaction_sk) references dim_indication(indication_sk)
);




