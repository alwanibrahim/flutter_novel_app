import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NovelListLoadingPlaceholder extends StatelessWidget {
  const NovelListLoadingPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Fake Cover
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 120,
                    width: 80,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Fake Text
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(3, (i) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: double.infinity,
                            height: i == 0 ? 16 : 14,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    })
                      ..add(Row(
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 60,
                              height: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 40,
                              height: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      )),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
