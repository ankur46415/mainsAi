// import '../../app_imports.dart';

// class CategoricalBookData extends StatefulWidget {
//   final String category;
//   final String? subCategory;

//   const CategoricalBookData({
//     super.key,
//     required this.category,
//     this.subCategory,
//   });

//   @override
//   State<CategoricalBookData> createState() => _CategoricalBookDataState();
// }

// class _CategoricalBookDataState extends State<CategoricalBookData> {
//   final controller = Get.find<HomeScreenController>();
//   final searchController = TextEditingController();
//   final searchQuery = ''.obs;
//   final filteredBooks = <Book>[].obs;
//   final isLoading = false.obs;
//   final RxBool isGridView = true.obs;

//   @override
//   void initState() {
//     super.initState();
//     _loadBooks();
//   }

//   Future<void> _loadBooks() async {
//     isLoading.value = true;
//     filteredBooks.value = await controller.fetchAllBooksForCategoryPaginated(
//       category: widget.category,
//       subCategory: widget.subCategory,
//     );
//     isLoading.value = false;
//   }

//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }

//   void _filterBooks(String query) {
//     searchQuery.value = query;
//     final searchLower = query.toLowerCase();
//     filteredBooks.value =
//         filteredBooks.where((book) {
//           return (book.paperName?.toLowerCase() ?? '').contains(searchLower) ||
//               (book.subjectName?.toLowerCase() ?? '').contains(searchLower) ||
//               (book.examName?.toLowerCase() ?? '').contains(searchLower);
//         }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: CustomAppBar(title: widget.category),
//       body: Column(
//         children: [_buildSearchBar(), Expanded(child: _buildBookGrid())],
//       ),
//     );
//   }

//   Widget _buildSearchBar() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: searchController,
//               decoration: InputDecoration(
//                 hintText: 'Search exam, paper, subject...',
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: Colors.grey),
//                 ),
//                 filled: true,
//                 fillColor: Colors.grey[50],
//               ),
//               onChanged: _filterBooks,
//             ),
//           ),
//           const SizedBox(width: 10),
//           Obx(
//             () => IconButton(
//               icon: Icon(
//                 isGridView.value ? Icons.view_list : Icons.grid_view_rounded,
//                 color: Colors.black87,
//               ),
//               onPressed: () => isGridView.toggle(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBookGrid() {
//     return Obx(() {
//       if (isLoading.value) {
//         return Center(
//           child: SizedBox(
//             height: 200,
//             width: 200,
//             child: Lottie.asset(
//               'assets/lottie/book_loading.json',
//               fit: BoxFit.contain,
//               delegates: LottieDelegates(
//                 values: [
//                   ValueDelegate.color(['**'], value: Colors.red),
//                 ],
//               ),
//             ),
//           ),
//         );
//       }
//       if (filteredBooks.isEmpty) {
//         return Center(
//           child: Text(
//             searchQuery.value.isEmpty
//                 ? 'No books available in this category'
//                 : 'No books found matching "${searchQuery.value}"',
//             style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 16),
//           ),
//         );
//       }
//       return RefreshIndicator(
//         onRefresh: _loadBooks,
//         child:
//             isGridView.value
//                 ? GridView.builder(
//                   padding: const EdgeInsets.all(12),
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 3,
//                     childAspectRatio: 0.7,
//                     crossAxisSpacing: 12,
//                     mainAxisSpacing: 12,
//                   ),
//                   itemCount: filteredBooks.length,
//                   itemBuilder:
//                       (context, index) => _buildBookCard(filteredBooks[index]),
//                 )
//                 : ListView.builder(
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   itemCount: filteredBooks.length,
//                   itemBuilder:
//                       (context, index) => _buildListItem(filteredBooks[index]),
//                 ),
//       );
//     });
//   }

//   Widget _buildBookCard(Book book) {
//     return InkWell(
//       onTap: () => Get.to(() => BookDetailsPage(bookId: book.bookId ?? '')),
//       child: Container(
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey),
//           borderRadius: BorderRadius.circular(6),
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(6),
//           child:
//               book.image_url == null || book.image_url!.isEmpty
//                   ? Center(
//                     child: Image.asset(
//                       'assets/images/nophoto.png',
//                       fit: BoxFit.contain,
//                       height: 60,
//                     ),
//                   )
//                   : Image.network(
//                     book.image_url!,
//                     fit: BoxFit.fill,
//                     errorBuilder:
//                         (context, error, stackTrace) => Container(
//                           color: Colors.grey[200],
//                           child: Center(
//                             child: Image.asset(
//                               'assets/images/nophoto.png',
//                               fit: BoxFit.contain,
//                               height: 60,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ),
//                   ),
//         ),
//       ),
//     );
//   }

//   Widget _buildListItem(Book book) {
//     return InkWell(
//       onTap: () => Get.to(() => BookDetailsPage(bookId: book.bookId ?? '')),
//       child: Card(
//         color: Colors.white,
//         margin: const EdgeInsets.only(bottom: 12),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         child: ListTile(
//           contentPadding: const EdgeInsets.all(12),
//           leading: ClipRRect(
//             borderRadius: BorderRadius.circular(6),
//             child: SizedBox(
//               height: 60,
//               width: 50,
//               child:
//                   book.image_url == null || book.image_url!.isEmpty
//                       ? Image.asset(
//                         'assets/images/nophoto.png',
//                         fit: BoxFit.cover,
//                       )
//                       : Image.network(
//                         book.image_url!,
//                         fit: BoxFit.cover,
//                         errorBuilder:
//                             (_, __, ___) =>
//                                 Image.asset('assets/images/nophoto.png'),
//                       ),
//             ),
//           ),
//           title: Text(
//             book.paperName ?? "Unknown Paper",
//             style: GoogleFonts.poppins(
//               fontWeight: FontWeight.w600,
//               fontSize: 13,
//             ),
//           ),
//           subtitle: Text(
//             "${book.subjectName ?? ''} • ${book.examName ?? ''}",
//             style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[700]),
//           ),
//         ),
//       ),
//     );
//   }
// }
