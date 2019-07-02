package com.ytfc.blog.utility;

import java.io.File;
import java.io.FileInputStream;
import java.util.Properties;

public class ConfigDataProvider {

    Properties props;

    public ConfigDataProvider() {
        File src = new File(System.getProperty("user.dir") + "/Config/Config.properties");
        FileInputStream fis;
        try {
            fis = new FileInputStream(src);
            props = new Properties();
            props.load(fis);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public String getBrowser() {
        return props.getProperty("browser");
    }

    public String getTestURI() {
        return props.getProperty("testURI");
    }
}
