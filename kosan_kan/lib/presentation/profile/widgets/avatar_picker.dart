import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AvatarPicker extends StatefulWidget {
  final double radius;
  final String? initialUrl;
  final void Function(XFile? file)? onChanged;

  const AvatarPicker({
    Key? key,
    this.radius = 36,
    this.initialUrl,
    this.onChanged,
  }) : super(key: key);

  @override
  State<AvatarPicker> createState() => _AvatarPickerState();
}

class _AvatarPickerState extends State<AvatarPicker> {
  XFile? _picked;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickFromGallery() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );
      if (file == null) return;
      setState(() => _picked = file);
      widget.onChanged?.call(file);
    } catch (e) {
      if (mounted) {
        final msg = e.toString();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal memilih gambar: $msg')));
      }
    }
  }

  Future<void> _pickFromCamera() async {
    try {
      // Note: on some emulators camera is unavailable; image_picker will throw.
      // We catch and surface the error below.
    } catch (_) {}
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );
      if (file == null) return;
      setState(() => _picked = file);
      widget.onChanged?.call(file);
    } catch (e) {
      if (mounted) {
        final msg = e.toString();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal mengambil foto: $msg')));
      }
    }
  }

  void _showPickerOptions() {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pilih dari galeri'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Ambil foto'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text('Batal'),
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAvatar() {
    final double r = widget.radius;
    if (_picked != null) {
      // On mobile platforms use FileImage
      if (!kIsWeb) {
        return CircleAvatar(
          radius: r,
          backgroundImage: FileImage(File(_picked!.path)),
        );
      } else {
        // Web: use NetworkImage via .path which is a data URL sometimes
        return CircleAvatar(
          radius: r,
          backgroundImage: NetworkImage(_picked!.path),
        );
      }
    }

    if (widget.initialUrl != null && widget.initialUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: r,
        backgroundImage: NetworkImage(widget.initialUrl!),
      );
    }

    return CircleAvatar(
      radius: r,
      backgroundColor: Colors.white,
      child: Icon(Icons.person, color: const Color(0xFF2AAE9E), size: r),
    );
  }

  // Permission handling removed to avoid plugin conflicts during build.
  // Rely on `image_picker` to request permissions and surface errors which we catch.

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _buildAvatar(),
        Positioned(
          right: -6,
          bottom: -6,
          child: Material(
            color: Colors.white,
            elevation: 2,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: _showPickerOptions,
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Icon(Icons.edit, size: 16, color: Color(0xFF2AAE9E)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
