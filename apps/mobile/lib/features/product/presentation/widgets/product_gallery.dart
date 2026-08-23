import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';

/// A simple paged image gallery for the product detail screen.
class ProductGallery extends StatefulWidget {
  const ProductGallery({super.key, required this.imageUrls});

  final List<String> imageUrls;

  @override
  State<ProductGallery> createState() => _ProductGalleryState();
}

class _ProductGalleryState extends State<ProductGallery> {
  final _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.imageUrls.isEmpty ? [''] : widget.imageUrls;
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.1,
          child: PageView.builder(
            controller: _controller,
            itemCount: images.length,
            onPageChanged: (index) => setState(() => _page = index),
            itemBuilder: (context, index) {
              final url = images[index];
              return DecoratedBox(
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest),
                child: url.isEmpty
                    ? const Center(child: Icon(Icons.image_outlined, size: 56))
                    : Image.network(
                        url,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(child: Icon(Icons.broken_image_outlined, size: 56)),
                      ),
              );
            },
          ),
        ),
        if (images.length > 1) ...[
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(images.length, (index) {
              final active = index == _page;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: active ? 16 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: active
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline,
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}
