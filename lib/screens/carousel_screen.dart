import 'package:flutter/material.dart';

class CarouselScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('M3 Expressive Carousel')),
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Hero (center aligned)'),
          const SizedBox(height: 8),
          SizedBox(
            height: 220,
            child: CarouselView.weighted(
              elevation: 0,
              enableSplash: false,
              itemSnapping: true,
              flexWeights: const [4, 10, 4],
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              children: List.generate(
                12,
                (i) => CarouselCard(
                  index: i,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class CarouselCard extends StatelessWidget {
  final int index;

  const CarouselCard({
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: cs.surfaceContainerHighest,
      elevation: 2,
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Visual emphasis (can be Image)
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: cs.primaryContainer,
                ),
                alignment: Alignment.center,
                child: Text(
                  'Item $index',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: cs.onPrimaryContainer,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(12),
              child: Text(
                'Subtitle • ${index + 1}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
