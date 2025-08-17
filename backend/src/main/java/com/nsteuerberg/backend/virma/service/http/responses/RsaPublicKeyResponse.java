package com.nsteuerberg.backend.virma.service.http.responses;

public record RsaPublicKeyResponse (
        String kty,
        String n,
        String e
){
}
