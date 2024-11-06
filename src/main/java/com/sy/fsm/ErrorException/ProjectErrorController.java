package com.sy.fsm.ErrorException;

import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import jakarta.servlet.http.HttpServletRequest;


@Controller
public class ProjectErrorController implements ErrorController {

    @RequestMapping("/error")
    public String handleError(HttpServletRequest request, Model model) {
        Object status = request.getAttribute("javax.servlet.error.status_code");

        if (status != null) {
            int statusCode = Integer.parseInt(status.toString());

            if (statusCode == 404) {
            	System.out.println("404 Error");
                model.addAttribute("error", "404 - Not Found");
                model.addAttribute("message", "The page you are looking for does not exist.");
                return "error/404";
            } else if (statusCode == 405) {
            	System.out.println("405 Error");
                model.addAttribute("error", "405 - Method Not Allowed");
                model.addAttribute("message", "The HTTP method is not allowed.");
                return "error/405";
            } else if (statusCode == 500) {
            	System.out.println("500 Error");
                model.addAttribute("error", "500 - Internal Server Error");
                model.addAttribute("message", "An unexpected error occurred on the server.");
                return "error/500";
            }
        }

        model.addAttribute("error", "Unknown Error");
        model.addAttribute("message", "An unexpected error occurred.");
        return "error/error";
    }
}
