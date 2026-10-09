import 'dart:math';

import 'package:app/src/application/theme/tokens.dart';
import 'package:flutter/material.dart';

/// Which icon leaves the page when the route can pop. Both pop.
enum PageLeading { back, close }

/// Scaffold shared by every page. The only widget that knows about the
/// content column: it caps the body at [columnWidth], centres it, and aligns
/// the app bar row and the floating action button to the same column.
///
/// The app bar appears when the route can pop, or there is a [title] or any
/// [actions]; without one the body sits below the status bar on its own.
/// The column gets a fixed 16 gutter unless [gutter] is false (lists and the
/// composer carry their own padding so dividers can run edge to edge).
/// [columnEdges] draws a hairline on each side of the column once the
/// viewport is wider than it.
class PageContainer extends StatelessWidget {
  const PageContainer({
    super.key,
    required this.body,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.columnWidth = kColumnWidthFeed,
    this.leading = PageLeading.back,
    this.canLeave = true,
    this.gutter = true,
    this.columnEdges = false,
  });

  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final double columnWidth;
  final PageLeading leading;

  /// False keeps the user on the page: the leading icon is greyed out and
  /// system back, browser back and swipe-back are blocked. For a page that
  /// must not be left mid-submit.
  final bool canLeave;
  final bool gutter;
  final bool columnEdges;

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    final hasAppBar = _hasAppBar(canPop);
    return PopScope(
      canPop: canLeave,
      child: LayoutBuilder(
        builder: (context, constraints) => Scaffold(
          appBar: hasAppBar ? _buildAppBar(context, canPop) : null,
          body: SafeArea(top: !hasAppBar, bottom: false, child: _buildColumn()),
          floatingActionButton: _alignToColumn(constraints.maxWidth),
        ),
      ),
    );
  }

  bool _hasAppBar(bool canPop) =>
      canPop || title != null || (actions?.isNotEmpty ?? false);

  AppBar _buildAppBar(BuildContext context, bool canPop) {
    final actions = this.actions ?? const <Widget>[];
    final title = this.title;
    return AppBar(
      automaticallyImplyLeading: false,
      title: _ColumnBox(
        width: columnWidth,
        child: Row(
          children: [
            if (canPop) ...[
              const SizedBox(width: Space.s1),
              _buildLeading(context),
              const SizedBox(width: Space.s2),
            ] else
              const SizedBox(width: Space.s4),
            Expanded(
              child: title == null ? const SizedBox.shrink() : Text(title),
            ),
            ...actions,
            if (actions.isNotEmpty) const SizedBox(width: Space.s4),
          ],
        ),
      ),
    );
  }

  Widget _buildLeading(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final isClose = leading == PageLeading.close;
    return IconButton(
      icon: Icon(isClose ? Icons.close : Icons.arrow_back),
      tooltip: isClose
          ? localizations.closeButtonTooltip
          : localizations.backButtonTooltip,
      onPressed: canLeave ? () => Navigator.of(context).pop() : null,
    );
  }

  Widget _buildColumn() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCapped = constraints.maxWidth > columnWidth;
        return _ColumnBox(
          width: columnWidth,
          fillHeight: true,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: columnEdges && isCapped ? _edges(context) : null,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: gutter ? Space.s4 : 0),
              child: body,
            ),
          ),
        );
      },
    );
  }

  Border _edges(BuildContext context) {
    return Border.symmetric(
      vertical: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
    );
  }

  /// Shifts the button in by the space outside the column, so it floats
  /// inside the column's end edge at every width.
  Widget? _alignToColumn(double availableWidth) {
    final button = floatingActionButton;
    if (button == null) return null;

    final inset = max(0.0, (availableWidth - columnWidth) / 2);
    return Padding(
      padding: EdgeInsetsDirectional.only(end: inset),
      child: button,
    );
  }
}

/// Centres [child] in a column of at most [width], always as wide as the
/// column allows. The app bar row only needs the width; the body also
/// fills the height so the column edges run to the bottom.
class _ColumnBox extends StatelessWidget {
  const _ColumnBox({
    required this.width,
    required this.child,
    this.fillHeight = false,
  });

  final double width;
  final Widget child;
  final bool fillHeight;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width),
        child: SizedBox(
          width: double.infinity,
          height: fillHeight ? double.infinity : null,
          child: child,
        ),
      ),
    );
  }
}
