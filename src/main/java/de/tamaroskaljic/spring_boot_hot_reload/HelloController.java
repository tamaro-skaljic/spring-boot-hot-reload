package de.tamaroskaljic.spring_boot_hot_reload;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/hello")
public class HelloController {

    public static int i = 0;

    @GetMapping
    public String hello() {
        return "Hello User" + ++i + "!";
    }

}