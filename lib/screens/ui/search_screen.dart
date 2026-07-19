import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:insta_clone/repository/firestore_methods.dart';
import 'package:insta_clone/screens/ui/profile_screen.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/widget/loader.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 16,
        title: Container(
          height: 44,
          decoration: BoxDecoration(
            color: mobileSearchColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: secondaryColor.withValues(alpha: 0.15),
            ),
          ),
          child: TextFormField(
            controller: _searchController,
            cursorColor: blueColor,
            style: const TextStyle(
              color: primaryColor,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            textAlignVertical: TextAlignVertical.center,
            decoration: const InputDecoration(
              hintText: 'Search',
              hintStyle: TextStyle(
                color: secondaryColor,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: secondaryColor,
                size: 22,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: 12,
              ),
            ),
            onChanged: (v) {
              setState(() {
                isShowUsers = v.isNotEmpty;
              });
            },
          ),
        ),
      ),
      body: isShowUsers
          ? StreamBuilder(
        stream: FireStoreMethods().searchUserByUserName(
          text: _searchController.text,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.person_search_outlined,
                    size: 68,
                    color: secondaryColor,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No users found',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Try searching with another username',
                    style: TextStyle(
                      color: secondaryColor,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 16,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot data = snapshot.data!.docs[index];

              return InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        uid: data['uid'].toString(),
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: mobileBackgroundColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: mobileBackgroundColor
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          backgroundColor: mobileBackgroundColor,
                          backgroundImage: NetworkImage(
                            data['photoUrl'],
                          ),
                          radius: 27,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          data['username'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      )
          : FutureBuilder(
        future: FireStoreMethods().getPostForSearchScreen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.photo_library_outlined,
                    size: 68,
                    color: secondaryColor,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No posts found',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Posts will appear here',
                    style: TextStyle(
                      color: secondaryColor,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: StaggeredGrid.count(
                crossAxisCount: 3,
                mainAxisSpacing: 3,
                crossAxisSpacing: 3,
                children:
                snapshot.data!.docs.asMap().entries.map((entry) {
                  int index = entry.key;
                  DocumentSnapshot data = entry.value;
                  bool isLarge = index % 7 == 0;

                  return StaggeredGridTile.count(
                    crossAxisCellCount: isLarge ? 2 : 1,
                    mainAxisCellCount: isLarge ? 2 : 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        data['postUrl'],
                        fit: BoxFit.cover,
                        loadingBuilder: (
                            context,
                            child,
                            loadingProgress,
                            ) {
                          if (loadingProgress == null) {
                            return child;
                          }

                          return Container(
                            color: mobileSearchColor,
                            alignment: Alignment.center,
                            child: const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: secondaryColor,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (
                            context,
                            error,
                            stackTrace,
                            ) {
                          return Container(
                            color: mobileSearchColor,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.broken_image_outlined,
                              color: secondaryColor,
                              size: 30,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}