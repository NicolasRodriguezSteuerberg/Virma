# Virma
Virma es una aplicación de de una plataforma de streaming tipo Netflix.

# Como funciona
Con `FFmpeg` se convierte archivos .mp4 a `HLS` y se utiliza `Nginx` para servir los videos.
Esto es útil para que el cliente vaya recogiendo videos de 10 segundos, lo que permite una visualizacion rápida.

# Que se utiliza
Se utiliza Spring boot para el backend, mientras que se usa Flutter para frontend
