*** Settings ***
Documentation       Robot Send Test Score LMS

Library             RPA.Browser.Selenium    auto_close=${FALSE}
Library             RPA.HTTP
Library             RPA.Excel.Files
Library             RPA.Dialogs
Library             RPA.Email.ImapSmtp    smtp_server=smtp.gmail.com    smtp_port=587


*** Variables ***
${WEB_ADDRESS}          https://school.moodledemo.net
${USERNAME}             vanhuychu1986@gmail.com
${PASSWORD}             mwtqeuvdhsoxihrp
${RECIPIENT_ADDRESS}    chuvanhuy@gmail.com


*** Tasks ***
Robot Send Test Score LMS
    Mở trình duyệt & Website
    Đăng nhập
    ${excel_file_path}=    Lấy file Excel từ phía người dùng
    Gửi Email    ${excel_file_path}
    Báo gửi Email thành công
    #[Teardown]    Thoát và đóng trình duyệt


*** Keywords ***
Mở trình duyệt & Website
    Open Available Browser    ${WEB_ADDRESS}/login/index.php

Đăng nhập
    Input Text    username    teacher
    Input Password    password    moodle
    Submit Form

Lấy file Excel từ phía người dùng
    Add heading    Tải File dữ liệu điểm muốn gửi
    Add file input
    ...    label=Tải File dữ liệu chứa điểm cần gửi tới người học qua Kênh Email
    ...    name=fileupload
    ...    file_type=Excel files (*.xls;*.xlsx)
    ...    destination=${OUTPUT_DIR}
    ${response}=    Run dialog
    RETURN    ${response.fileupload}[0]

Gửi Email
    [Arguments]    ${excel_file_path}
    Open Workbook    ${excel_file_path}
    ${gui_emails}=    Read Worksheet As Table    header=True
    Close Workbook

    FOR    ${gui_email}    IN    @{gui_emails}
        Authorize    account=${USERNAME}    password=${PASSWORD}
        Send Message    sender=${USERNAME}
        ...    recipients=${gui_email}[Email người học]
        ...    subject=${gui_email}[Tiêu đề Email]
        ...    body=${gui_email}[Nội dung Email]
    END

Báo gửi Email thành công
    Add icon    Success
    Add heading    Bạn đã gửi tất cả Email thành công
    Run dialog    title=Thông báo

# Thoát và đóng trình duyệt
    # Click Element    ${WEB_ADDRESS}/login/logout.php
    # Close Browser
