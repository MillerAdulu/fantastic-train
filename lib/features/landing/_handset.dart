// import 'package:auto_route/auto_route.dart';
// import 'package:demo25/l10n/l10n.dart';
// import 'package:demo25/shared_widgets/empty_state.dart';
// import 'package:demo25/shared_widgets/input/text/text.dart';
// import 'package:demo25/shared_widgets/navbar/navbar.dart';
// import 'package:demo25/shared_widgets/progress/linear_progress_indicator.dart';
// import 'package:demo25/utils/debouncer.dart';
// import 'package:demo25/utils/router/router.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:logger/logger.dart';

// class LandingPageHandset extends StatefulWidget {
//   const LandingPageHandset({super.key});

//   @override
//   State<LandingPageHandset> createState() => _LandingPageHandsetState();
// }

// class _LandingPageHandsetState extends State<LandingPageHandset> {
//   String? _searchQuery;

//   final TextEditingController _searchController = TextEditingController();

//   final _searchDebouncer = Debouncer(milliseconds: 1000);

//   @override
//   void initState() {
//     context.read<GetFaqsCubit>().getFaqs();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _searchDebouncer.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final l10n = context.l10n;
//     final theme = Theme.of(context);

//     return Scaffold(
//       body: SafeArea(
//         child: CustomScrollView(
//           slivers: [
//             // Modern Navigation Bar
//             FCNavBar(
//               title: 'Widgets',
//               // onBack: () => context.router.popUntilRouteWithPath(
//               //   FCRouter.studentLandingRoute,
//               // ),
//               backgroundColor: theme.colorScheme.surface,
//             ),
//             // Search Field
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: FCTextInput(
//                   hintText: l10n.whatWouldYouLikeToKnow,
//                   controller: _searchController,
//                   onChanged: (value) {
//                     setState(() {
//                       _searchQuery = value;
//                     });
//                     Logger().i('Search Query: $_searchQuery');
//                     _searchDebouncer.run(() {
//                       context.read<GetFaqsCubit>().getFaqs(
//                         categoryUlid: _selectedCategory?.ulid,
//                         query: (_searchQuery?.isNotEmpty ?? false)
//                             ? _searchQuery
//                             : null,
//                       );
//                     });
//                   },
//                 ),
//               ),
//             ),
//             const SliverToBoxAdapter(child: SizedBox(height: 16)),

//             // Loading Indicator
//             SliverToBoxAdapter(
//               child: BlocBuilder<GetFaqsCubit, GetFaqsState>(
//                 builder: (context, state) => state.maybeWhen(
//                   loading: () => const FCLinearProgressIndicator(),
//                   orElse: () => const SizedBox.shrink(),
//                 ),
//               ),
//             ),
//             const SliverToBoxAdapter(child: SizedBox(height: 16)),

//             // FAQ List
//             BlocBuilder<GetFaqsCubit, GetFaqsState>(
//               builder: (context, state) {
//                 return state.maybeWhen(
//                   orElse: () =>
//                       const SliverToBoxAdapter(child: SizedBox.shrink()),
//                   error: (message) =>
//                       SliverFillRemaining(child: Center(child: Text(message))),
//                   empty: () => SliverFillRemaining(
//                     child: RefreshIndicator(
//                       onRefresh: () => context.read<GetFaqsCubit>().getFaqs(
//                         forceRefresh: true,
//                       ),
//                       child: FCEmptyView(
//                         label: 'No widgets found',
//                         description: 'Try adjusting your search or filter to find what you are looking for.',
//                       ),
//                     ),
//                   ),
//                   loaded: (faqs) {
//                     return SliverList.separated(
//                       itemCount: faqs.length,
//                       separatorBuilder: (context, index) =>
//                           const SizedBox(height: 12),
//                       itemBuilder: (context, index) =>
//                           FaqCard(faq: faqs[index]),
//                     );
//                   },
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class FaqCard extends StatelessWidget {
//   const FaqCard({required this.faq, super.key});

//   final FCLocalFaq faq;

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Animate(
//       effects: const [SaturateEffect()],
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: theme.colorScheme.surface,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: theme.colorScheme.shadow.withValues(alpha: 0.08),
//               blurRadius: 16,
//               offset: const Offset(0, 4),
//             ),
//             BoxShadow(
//               color: theme.colorScheme.shadow.withValues(alpha: 0.04),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//           border: Border.all(
//             color: theme.colorScheme.outline.withValues(alpha: 0.1),
//           ),
//         ),
//         child: ExpansionTile(
//           tilePadding: EdgeInsets.zero,
//           title: Text(
//             faq.question,
//             style: theme.textTheme.titleMedium?.copyWith(
//               fontWeight: FontWeight.w600,
//               color: theme.colorScheme.onSurface,
//             ),
//           ),
//           children: [
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
//                 child: Text(
//                   faq.answer,
//                   style: theme.textTheme.bodyMedium?.copyWith(
//                     color: theme.colorScheme.onSurfaceVariant,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
