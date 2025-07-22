package com.nsteuerberg.backend.virma.presentation.controller;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;


@RestController
@RequestMapping("test_video")
public class TestVideo {

    private Path path_file = Paths.get("/Users/nsteuerberg/Documents/Videos/MP4");
    private Path hls_path_file = Paths.get("/Users/nsteuerberg/Documents/Videos/HLS");

    @PostMapping("")
    @ResponseStatus(HttpStatus.OK)
    public void uploadFile(@RequestParam("file") MultipartFile file) throws IOException, InterruptedException {
        // guardamos el archivo .mp4 tal cual
        Path destination = path_file.resolve(Paths.get(file.getOriginalFilename()))
                .normalize().toAbsolutePath();
        Files.copy(file.getInputStream(), destination, StandardCopyOption.REPLACE_EXISTING);

        // 2. Preparar ruta de salida HLS
        String fileNameWithoutExt = file.getOriginalFilename().replaceFirst("[.][^.]+$", "");
        Path outputDir = hls_path_file;
        Files.createDirectories(outputDir);

        // 3. Construir comando FFmpeg
        String inputFile = destination.toString();
        String outputM3U8 = outputDir.resolve("index.m3u8").toString();

        ProcessBuilder pb = new ProcessBuilder(
                "ffmpeg",
                "-i", inputFile,
                "-codec:", "copy",
                "-start_number", "0",
                "-hls_time", "10",
                "-hls_list_size", "0",
                "-f", "hls",
                outputM3U8
        );
        pb.inheritIO();

        // 4. Ejecutar proceso
        Process process = pb.start();
        int exitCode = process.waitFor();
        if (exitCode != 0) {
            throw new RuntimeException("FFmpeg failed with exit code " + exitCode);
        }
    }
}
