package com.eni.suntech.web;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class Controller {

    @GetMapping("hello")
    public String afficherMessage() {

        return "Bonjour, votre application fonctionne !";
    }
}