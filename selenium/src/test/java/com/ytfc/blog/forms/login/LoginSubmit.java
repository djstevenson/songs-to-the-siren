package com.ytfc.blog.forms.login;

import com.ytfc.blog.forms.FormButton;

import org.openqa.selenium.WebDriver;

public class LoginSubmit extends FormButton {

    public LoginSubmit(WebDriver driver) {
        super(driver, "login-button");
    }

    
}
