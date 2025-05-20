enum AppPermission {
  notifications,
  camera,
  gallery,
  location;

  String get deniedMessage {
    switch (this) {
      case AppPermission.notifications:
        return 'Permissão para notificações negada. Habilite nas configurações.';
      case AppPermission.camera:
        return 'Permissão da câmera negada. Habilite nas configurações.';
      case AppPermission.gallery:
        return 'Permissão da galeria negada. Habilite nas configurações.';
      case AppPermission.location:
        return 'Permissão de localização negada. Habilite nas configurações.';
    }
  }
}
