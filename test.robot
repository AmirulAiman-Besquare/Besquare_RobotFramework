*** Settings ***
Library           SeleniumLibrary
Resource          common.robot

*** Variable ***
${login_btn}            dt_login_button
${email_field}          name=email
${pw_field}             //*[@type="password"]
${submit_login}         //*[text()="Log in"]
${chart_loader}         //*[@class="chart-container__loader"]
${header_preloader}     //*[@id="dt_core_header_acc-info-preloader"]
${initial_page_loader}       //*[@class="initial-loader account__initial-loader"]
${input_amount}         //*[@id="dt_amount_input"]
${underlying_asset_button}          //*[@class="cq-chart-price"]
${disabled_button}                  //*[@class="trade-container__fieldset-wrapper trade-container__fieldset-wrapper--disabled"]
${options_dropdown}                 //*[@id="dt_contract_dropdown"]
${date_amount}                      //*[@id="dt_advanced_duration_datepicker"]
${syn_indx}             //*[text()="Synthetic Indices"]
${deal_cancel_fee}      //*[@id="dt_purchase_multup_price"]/div/div[2]/span
${max_stake_error}      Maximum stake allowed is 2000.00.
${min_stake_error}      Please enter a stake amount that's at least 1.00.
${checkbox}             @class, " dc-checkbox"
${token_name_field}           //*[@name="token_name"]
${api_delete_btn}             //*[text()="Delete"]//parent::button
${api_yes_btn}                //*[text()="Yes"]//parent::button
${api_create_button}          //*[@class="dc-btn dc-btn__effect dc-btn--primary dc-btn__large da-api-token__button"]
${api_name_error}             //*[@class="dc-input da-api-token__input dc-input--error"]

*** Test Cases ***
Test1
    Login       ${my_email}     ${my_pass}

Test2
    BuyRise

Test3
    BuyLower

Test4
    CheckBarrier

Test5
    CheckMultiplier

Test6
    TC02
    TC03
    TC04
    TC05
    TC06
    TC07
    TC08
    TC09
    TC10
    TC11
    TC12
    TC13
    TC14