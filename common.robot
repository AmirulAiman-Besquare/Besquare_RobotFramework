*** Settings ***
Documentation    Suite description
Library           SeleniumLibrary
Library             String

*** Variable ***

*** Keyword ***
Login
    [arguments]     ${email}    ${pw}
    Open Browser    https://app.deriv.com  chrome
    wait until page does not contain     ${chart_loader}
    set window size     1280    1280
    wait until page contains element    ${login_btn}       60
    click element   ${login_btn}
    wait until page contains element    ${email_field}     15
    input text      ${email_field}     ${email}
    input password  ${pw_field}      ${pw}
    click element   ${submit_login}
    wait until page does not contain element   ${header_preloader}   60
    wait until page does not contain element     ${chart_loader}
    wait until page contains element    dt_core_account-info_acc-info     60
    click element   dt_core_account-info_acc-info
    click element   //*[@id="dt_core_account-switcher_demo-tab"]
    click element    //*[contains(@id,"dt_VRTC")]

BuyRise
    wait until page does not contain     ${chart_loader}
    wait until page contains element    ${underlying_asset_button}    60
    click element   ${underlying_asset_button}
    wait until page contains element    ${syn_indx}      60
    click element   ${syn_indx}
    wait until page contains element    //*[text()="Volatility 10 (1s) Index"]      60
    click element   //*[text()="Volatility 10 (1s) Index"]
    wait until page does not contain element    ${header_preloader}    60
    wait until page does not contain element     ${chart_loader}
    wait until page does not contain element     ${disabled_button}      60
    wait until page contains element     //*[@id="dt_purchase_call_button"]      60
    click button    //*[@id="dt_purchase_call_button"]
    sleep       5

BuyLower
    wait until page does not contain     ${chart_loader}
    wait until page contains element    ${underlying_asset_button}    60
    click element   ${underlying_asset_button}
    wait until page contains element    //*[text()="Forex"]      60
    click element   //*[text()="Forex"]
    wait until page contains element    //*[text()="AUD/USD"]      60
    click element   //*[text()="AUD/USD"]
    wait until page contains element   ${options_dropdown}
    click element  ${options_dropdown}
    wait until page contains element    dt_contract_high_low_item
    click element   dt_contract_high_low_item
    wait until page contains element    dt_simple_toggle
    click element   dt_simple_toggle
    wait until page contains element    ${date_amount}
    click element   ${date_amount}/div/div/input
    clear element text      ${date_amount}/div/div/input
    input text      ${date_amount}/div/div/input   2
    wait until page contains element    dc_payout_toggle_item
    click element   dc_payout_toggle_item
    click element   ${input_amount}
    press keys      ${input_amount}      CTRL+A      DELETE
    input text      ${input_amount}        15.50
    wait until page does not contain element     ${disabled_button}      60
    click button   dt_purchase_put_button

CheckBarrier
    press keys      //*[@id="dt_barrier_1_input"]     CTRL+A      DELETE
    input text      //*[@id="dt_barrier_1_input"]       +0.1
    press keys      ${input_amount}      CTRL+A      DELETE
    input text      ${input_amount}        10
    wait until page contains    Contracts more than 24 hours in duration would need an absolute barrier.     60

CheckMultiplier

#a. Only stake is allowed. Should not have payout option
    wait until page does not contain     ${chart_loader}
    wait until page contains element    ${underlying_asset_button}    60
    click element   ${underlying_asset_button}
    wait until page contains element    ${syn_indx}      60
    click element   ${syn_indx}
    wait until page contains element    //*[text()="Volatility 50 (1s) Index"]      60
    click element   //*[text()="Volatility 50 (1s) Index"]
    wait until page does not contain element     ${header_preloader}    60
    wait until page does not contain element     ${chart_loader}
    wait until page contains element   ${options_dropdown}
    click element  ${options_dropdown}
    wait until page contains element    dt_contract_multiplier_item
    click element   dt_contract_multiplier_item
    page should not contain   Payout

#b. Only deal cancellation or take profit/stop loss is allowed
#c. Multiplier value selection should have x20, x40, x60, x100, x200
    click element   //*[text()="Take profit"]
    checkbox should be selected     //*[@id="dc_take_profit-checkbox_input"]
    click element   //*[text()="Stop loss"]
    checkbox should be selected     //*[@id="dc_stop_loss-checkbox_input"]
    click element   //*[@id="dropdown-display"]/span
    page should contain element    //*[@id="20"]
    page should contain element    //*[@id="40"]
    page should contain element    //*[@id="60"]
    page should contain element    //*[@id="100"]
    page should contain element    //*[@id="200"]
    click element   //*[text()="Take profit"]
    click element   //*[text()="Stop loss"]
    sleep   2
    click element   //*[text()="Deal cancellation"]
    checkbox should be selected     //*[@id="dt_cancellation-checkbox_input"]
    checkbox should not be selected     //*[@id="dc_take_profit-checkbox_input"]
    checkbox should not be selected     //*[@id="dc_stop_loss-checkbox_input"]

#d. Deal cancellation fee should correlates with the stake value (e.g. deal cancellation fee is more expensive when the stake is higher)
    press keys      ${input_amount}      CTRL+A      DELETE
    input text      ${input_amount}      10
    wait until page contains element        ${deal_cancel_fee}     60
    ${first_value}=    Get Text         ${deal_cancel_fee}
    ${first_value}=     remove string       ${first_value}     USD
    convert to number       ${first_value}
    press keys      ${input_amount}      CTRL+A      DELETE
    input text      ${input_amount}      20
    wait until page contains element        ${deal_cancel_fee}     60
    ${second_value}=    Get Text        ${deal_cancel_fee}
    ${second_value}=    remove string       ${second_value}     USD
    convert to number       ${second_value}
    should be true      ${second_value} > ${first_value}

    press keys      ${input_amount}      CTRL+A      DELETE
    input text      ${input_amount}      20
    wait until page contains element        ${deal_cancel_fee}     60
    ${first_value}=    Get Text       ${deal_cancel_fee}
    ${first_value} =    remove string       ${first_value}     USD
    convert to number       ${first_value}
    press keys      ${input_amount}      CTRL+A      DELETE
    input text      ${input_amount}      10
    wait until page contains element        ${deal_cancel_fee}     60
    ${second_value}=    Get Text     ${deal_cancel_fee}
    ${second_value}=    remove string       ${second_value}     USD
    convert to number       ${second_value}
    should be true      ${second_value} < ${first_value}

#e. Maximum stake is 2000 USD
    click element   ${input_amount}
    press keys      ${input_amount}      CTRL+A      DELETE
    input text      ${input_amount}      2001
    wait until page contains    ${max_stake_error}
    page should contain     ${max_stake_error}
    sleep   3

#f. Minimum stake is 1 USD
    press keys      ${input_amount}      CTRL+A      DELETE
    input text      ${input_amount}      0.1
    wait until page contains    ${min_stake_error}
    page should contain     ${min_stake_error}
    sleep   3

#g. Single click on plus (+) button of take profit field should increase the stake value by 1 USD
    press keys      ${input_amount}      CTRL+A      DELETE
    input text      ${input_amount}      10
    ${current_value}=    Get Element Attribute    ${input_amount}     value
    click element       //*[@id="dt_amount_input_add"]
    ${new_value}=    Get Element Attribute    ${input_amount}     value
    ${expected_value}=      Evaluate     ${current_value}+1
    should be equal as integers   ${new_value}       ${expected_value}        ignore_case=True
    ${current_value}=    Get Element Attribute    ${input_amount}     value

#h. Single click on minus (-) button of take profit field should decrease the stake value by 1 USD
    click element       //*[@id="dt_amount_input_sub"]
    ${new_value}=    Get Element Attribute    ${input_amount}     value
    ${expected_value}=      Evaluate     ${current_value}-1
    should be equal as integers   ${new_value}       ${expected_value}        ignore_case=True

#i. Deal cancellation duration only has these options: 5,10,15,30 and 60 min
    click element   //*[@class="trade-container__fieldset"]//child::div[@id="dropdown-display"]
    page should contain element    //*[@id="5m"]
    page should contain element    //*[@id="10m"]
    page should contain element    //*[@id="15m"]
    page should contain element    //*[@id="30m"]
    page should contain element    //*[@id="60m"]

TC02
    click element       //*[@class="account-settings-toggle"]
    sleep   2
    wait until page does not contain element    ${initial_page_loader}
    sleep   5
    click element       dc_api-token_link
    wait until page does not contain element    ${initial_page_loader}
    page should contain     Select scopes based on the access you need.

TC03
    click element       //*[text()="Read" and contains(${checkbox})]
    checkbox should be selected     //*[@name="read"]
    click element       //*[text()="Trade" and contains(${checkbox})]
    checkbox should be selected      //*[@name="trade"]
    click element       //*[text()="Payments" and contains(${checkbox})]
    checkbox should be selected     //*[@name="payments"]
    click element        //*[text()="Admin" and contains(${checkbox})]
    checkbox should be selected     //*[@name="admin"]
    click element       //*[text()="Trading information" and contains(${checkbox})]
    checkbox should be selected     //*[@name="trading_information"]

TC04
    click element       //*[text()="Read" and contains(${checkbox})]
    checkbox should not be selected     //*[@name="read"]
    click element       //*[text()="Trade" and contains(${checkbox})]
    checkbox should not be selected      //*[@name="trade"]
    click element       //*[text()="Payments" and contains(${checkbox})]
    checkbox should not be selected     //*[@name="payments"]
    click element        //*[text()="Admin" and contains(${checkbox})]
    checkbox should not be selected     //*[@name="admin"]
    click element       //*[text()="Trading information" and contains(${checkbox})]
    checkbox should not be selected     //*[@name="trading_information"]

TC05
    input text      ${token_name_field}     11
    page should not contain element    ${api_name_error}

TC06
    press keys      ${token_name_field}        CTRL+A      DELETE
    input text      ${token_name_field}     1
    page should contain element    ${api_name_error}

TC07
    input text      ${token_name_field}     111111111111111111111111111111111
    page should contain     Maximum 32 characters.

TC08
    RELOAD PAGE
    wait until page does not contain element    ${initial_page_loader}     10
    click element       //*[text()="Read" and contains(${checkbox})]
    click element       //*[text()="Trade" and contains(${checkbox})]
    click element       //*[text()="Payments" and contains(${checkbox})]
    click element        //*[text()="Admin" and contains(${checkbox})]
    click element       //*[text()="Trading information" and contains(${checkbox})]
    input text      ${token_name_field}     testing
    click element    ${api_create_button}

TC09
    RELOAD PAGE
    wait until page does not contain element    ${initial_page_loader}     10
    click element       //*[text()="Read" and contains(${checkbox})]
    input text      ${token_name_field}     testing
    click element    ${api_create_button}

TC10
    RELOAD PAGE
    wait until page does not contain element    ${initial_page_loader}     10
    click element       //*[text()="Trade" and contains(${checkbox})]
    input text      ${token_name_field}     testing
    click element    ${api_create_button}

TC11
    RELOAD PAGE
    wait until page does not contain element    ${initial_page_loader}     10
    click element       //*[text()="Payments" and contains(${checkbox})]
    input text      ${token_name_field}     testing
    click element    ${api_create_button}

TC12
    RELOAD PAGE
    wait until page does not contain element    ${initial_page_loader}     10
    click element        //*[text()="Admin" and contains(${checkbox})]
    input text      ${token_name_field}     testing
    click element    ${api_create_button}

TC13
    RELOAD PAGE
    wait until page does not contain element    ${initial_page_loader}     10
    click element       //*[text()="Trading information" and contains(${checkbox})]
    input text      ${token_name_field}     testing
    click element    ${api_create_button}

TC14
    sleep       2
    wait until page contains element    //*[text()="Delete"]
    click element      ${api_delete_btn}
    click element      ${api_yes_btn}
    sleep       2
    click element      ${api_delete_btn}
    click element      ${api_yes_btn}
    sleep       2
    click element      ${api_delete_btn}
    click element      ${api_yes_btn}
    sleep       2
    click element      ${api_delete_btn}
    click element      ${api_yes_btn}
    sleep       2
    click element      ${api_delete_btn}
    click element      ${api_yes_btn}
    sleep       2
    click element      ${api_delete_btn}
    click element      ${api_yes_btn}