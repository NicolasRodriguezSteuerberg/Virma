package com.nsteuerberg.backend.virma.presentation.controller;

import com.nsteuerberg.backend.virma.presentation.dto.request.UserCreateRequest;
import com.nsteuerberg.backend.virma.service.implementation.UserServiceImpl;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("user")
public class UserController {
    private final UserServiceImpl userService;

    public UserController(UserServiceImpl userService) {
        this.userService = userService;
    }

    @PostMapping
    @ResponseStatus(HttpStatus.OK)
    public void createUser(@RequestBody UserCreateRequest userCreateRequest) {
        // ToDo agregar la autenticacion y recoger el id del JwtToken
        userService.saveUser(userCreateRequest, 1L);
    }
}
