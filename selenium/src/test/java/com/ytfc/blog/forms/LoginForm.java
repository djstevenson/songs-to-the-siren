package com.ytfc.blog.forms;

import java.util.HashMap;

import com.ytfc.blog.forms.login.LoginSubmit;
import com.ytfc.blog.forms.login.NameField;
import com.ytfc.blog.forms.login.PasswordField;

import org.openqa.selenium.WebDriver;

public class LoginForm extends FormObject {

    public LoginForm(WebDriver driver) {
        super(driver);

        fields = new HashMap<String, FormField>();

        fields.put("name", new NameField(driver));
        fields.put("password", new PasswordField(driver));

        button = new LoginSubmit(driver);
    }


}
