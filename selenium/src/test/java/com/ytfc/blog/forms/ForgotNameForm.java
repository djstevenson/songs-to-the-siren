package com.ytfc.blog.forms;

import java.util.HashMap;

import com.ytfc.blog.forms.forgotname.FormSubmit;
import com.ytfc.blog.forms.forgotname.EmailField;

import org.openqa.selenium.WebDriver;

public class ForgotNameForm extends FormObject {

    public ForgotNameForm(WebDriver driver) {
        super(driver);

        fields = new HashMap<String, FormField>();

        fields.put("email", new EmailField(driver));

        button = new FormSubmit(driver);
    }


}
