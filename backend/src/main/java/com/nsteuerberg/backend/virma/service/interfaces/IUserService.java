package com.nsteuerberg.backend.virma.service.interfaces;

import com.nsteuerberg.backend.virma.presentation.dto.request.UserCreateRequest;

public interface IUserService {
    void saveUser(UserCreateRequest userCreateRequest);
}
