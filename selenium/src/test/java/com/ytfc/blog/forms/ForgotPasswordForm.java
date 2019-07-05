package com.ytfc.blog.forms;

import java.util.HashMap;

import com.ytfc.blog.forms.forgotpassword.FormSubmit;
import com.ytfc.blog.forms.forgotpassword.EmailField;

import org.openqa.selenium.WebDriver;

public class ForgotPasswordForm extends FormObject {

    public ForgotPasswordForm(WebDriver driver) {
        super(driver);

        fields = new HashMap<String, FormField>();

        fields.put("email", new EmailField(driver));

        button = new FormSubmit(driver);
    }


}
