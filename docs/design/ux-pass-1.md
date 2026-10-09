# UX pass 1: one product instead of framework defaults

Companion artboard: [`ux-pass-1-artboard.html`](ux-pass-1-artboard.html) (every frame below, 390x844, light and dark, plus 768 and 1280). The artboard is the visual source of truth; this document gives the values.

## Summary

- **No screen moves and no feature is added.** The five routes stay where they are. What changes is a design system (`ThemeData` built from explicit tokens), the shape of three screens (auth forms, feed row, composer), and which failures are inline versus snackbar.
- **Look.** Warm off-white surface (`#FAF9F6`), near-black ink as the brand primary (buttons, FAB, focus), one coral accent reserved for a liked heart, hairline dividers, 12dp radii. No blue. Dark mode inverts ink and bone. Type is the platform default family (Roboto on Android and web, SF on iOS) on the scale below; no font dependency.
- **Structure.** Auth screens get a heading in the body (`Welcome back` / `Create your account`) and a top-aligned form that does not jump when the keyboard opens. The feed row reads owner · time / content / heart. The composer loses the check icon and gets a `Tweet` pill in the app bar, an `X` to leave, and a remaining-characters counter.
- **Decided on review**: platform font (not DM Sans); coral for the heart; `X` on compose; `Welcome back` as the sign-in heading; timestamps keep the long form (`3 minutes ago`).

## Goals

- Every pixel on the five screens reads from one token set, so the app looks like one product in light, dark, English and Spanish.
- Each screen has one obvious primary action reachable with a thumb at 390 wide, and nothing competing with it.
- Failures the user can fix are shown where they fix them; failures they cannot fix are transient and do not block the screen.

## Tokens

All values are Flutter `ColorScheme` / `TextTheme` roles so the engineer builds one `AppTheme.light()` / `AppTheme.dark()` in `lib/src/application/theme/` and nothing else carries a colour, size or radius literal. `Application` passes those two `ThemeData`s; `themeMode` stays `ThemeMode.system`.

### ColorScheme (explicit, not seeded)

| Role | Light | Dark | Used for |
| --- | --- | --- | --- |
| `surface` | `#FAF9F6` | `#131416` | scaffold, app bar, fields |
| `onSurface` | `#1B1D22` | `#ECEAE4` | body text, headings, icons |
| `onSurfaceVariant` | `#5B5F67` | `#A8ABB2` | secondary text: time, counter, labels, hints, empty-state icon |
| `surfaceContainer` | `#F1EFEA` | `#1C1D21` | hover tint on feed rows (web) |
| `surfaceContainerHighest` | `#E9E7E1` | `#2A2C31` | avatar circle, tonal button, disabled field fill |
| `outline` | `#80848C` | `#74777E` | field border (enabled) |
| `outlineVariant` | `#E2E0DA` | `#2E3036` | hairlines: dividers, column edges |
| `primary` | `#1B1D22` | `#F2F1EC` | filled button, FAB, focused border, link, spinner |
| `onPrimary` | `#FFFFFF` | `#1B1D22` | text/icon on primary |
| `primaryContainer` | `#E9E7E1` | `#2A2C31` | unused by screens; set so M3 defaults stay coherent |
| `onPrimaryContainer` | `#1B1D22` | `#ECEAE4` | idem |
| `secondary` | `#5B5F67` | `#A8ABB2` | = onSurfaceVariant; unused directly |
| `tertiary` | `#D23B2C` | `#FF7A6B` | **liked heart only** (name it `like` in a comment) |
| `error` | `#B3261E` | `#FFB4AB` | field error border and text, near-limit counter |
| `onError` | `#FFFFFF` | `#690005` | – |
| `errorContainer` | `#F9DEDC` | `#93000A` | inline form-error block background |
| `onErrorContainer` | `#410E0B` | `#FFDAD6` | inline form-error text and icon |
| `inverseSurface` | `#2F3136` | `#ECEAE4` | snackbar background |
| `onInverseSurface` | `#F2F1ED` | `#1B1D22` | snackbar text |
| `inversePrimary` | `#FFFFFF` | `#1B1D22` | snackbar action (none used today) |
| `surfaceTint` | `transparent` | `transparent` | no M3 tint on elevation |
| `shadow` | `#000000` | `#000000` | FAB only |

Measured contrast (WCAG): `onSurface`/`surface` 16.0:1 light, 15.3:1 dark; `onSurfaceVariant`/`surface` 6.1 / 8.0; `onSurfaceVariant`/`surfaceContainerHighest` 5.2 / 6.1; `outline`/`surface` 3.6 / 4.1 (component minimum 3:1); `tertiary`/`surface` 4.5 / 7.2; `error`/`surface` 6.2 / 10.9; `onErrorContainer`/`errorContainer` 12.8 / 7.2; `onInverseSurface`/`inverseSurface` 11.5 / 14.0; `onPrimary`/`primary` 16.9 / 14.9. Disabled (onSurface at 38 %) is exempt as inactive UI.

### Type scale (`TextTheme`)

Family: the **platform default** (Roboto on Android and web, SF on iOS), decided on review so the app adds no font dependency and the web build stays deterministic. The scale below is applied to it as an explicit `TextTheme` (`lib/src/application/theme/app_text_theme.dart`); nothing else changes.

| Role | Size / line | Weight | Letter spacing | Used for |
| --- | --- | --- | --- | --- |
| `headlineMedium` | 28 / 34 | 700 | −0.5 | auth headings |
| `titleLarge` | 20 / 26 | 700 | −0.25 | app bar titles |
| `titleMedium` | 16 / 22 | 600 | 0 | avatar initial |
| `titleSmall` | 15 / 20 | 600 | 0 | feed owner |
| `bodyLarge` | 16 / 24 | 400 | 0 | tweet content, composer text, message views, field input |
| `bodyMedium` | 14 / 20 | 400 | 0 | field label (resting), inline form error, snackbar |
| `bodySmall` | 13 / 18 | 400 | 0 | time ago, counter, field helper / error, floating label |
| `labelLarge` | 15 / 20 | 600 | 0 | buttons, `Tweet` pill, text link |
| `labelMedium` | 13 / 16 | 600 | 0 | like count |

Sizes are logical pixels (sp on device; the app respects `textScaler`, see Accessibility).

### Spacing (4-based)

`s1 4`, `s2 8`, `s3 12`, `s4 16`, `s5 24`, `s6 32`, `s7 48`. Screen gutter is `s4` at every width (replaces the current 5 % of viewport). Declare them as `abstract final class Space` next to the theme.

### Radii

`rSm 8` (inline error block, avatar fallback not needed: avatars are circles), `rMd 12` (fields, buttons, snackbar), `rLg 16` (FAB), `rFull 999` (`Tweet` pill, avatar).

### Component themes

- `AppBarTheme`: `backgroundColor surface`, `foregroundColor onSurface`, `elevation 0`, `scrolledUnderElevation 0`, `surfaceTintColor transparent`, `centerTitle false` (same on iOS and web), `titleTextStyle titleLarge`, `toolbarHeight 56`, `titleSpacing 0` when a leading icon exists (default 16 otherwise), icon size 24. No bottom hairline.
- `FilledButtonThemeData`: `minimumSize Size(64, 48)`, `padding h24`, `shape RoundedRectangleBorder(rMd)`, `textStyle labelLarge`, bg `primary`, fg `onPrimary`; hover overlay `onPrimary` 8 %, pressed 12 %, focus 12 % (Flutter draws the overlay; on web keyboard focus also gets `side: BorderSide(primary, 2)` via `WidgetStateProperty` when `focused && !hovered`); disabled bg `onSurface` 12 %, fg `onSurface` 38 %. **Tonal** (`FilledButton.tonal`, used for `Try again`): bg `surfaceContainerHighest`, fg `onSurface`, same shape and size.
- `TextButtonThemeData`: fg `primary`, `textStyle labelLarge`, `minimumSize Size(48, 44)`, `padding h12`, overlay `primary` 8 % hover / 12 % pressed.
- `InputDecorationTheme`: `border/enabledBorder OutlineInputBorder(rMd, outline 1)`, `focusedBorder (rMd, primary 2)`, `errorBorder (rMd, error 1)`, `focusedErrorBorder (rMd, error 2)`, `filled false`, `contentPadding h16 v16` (field height 56), `labelStyle bodyMedium onSurfaceVariant`, `floatingLabelStyle bodySmall primary` (error: `error`), `hintStyle bodyLarge onSurfaceVariant`, `helperStyle bodySmall onSurfaceVariant`, `errorStyle bodySmall error`, `errorMaxLines 2`. Read-only (while submitting): `fillColor surfaceContainerHighest`, `filled true`, text `onSurfaceVariant`; the engineer sets this per field from `isSubmitting`.
- `FloatingActionButtonThemeData`: `backgroundColor primary`, `foregroundColor onPrimary`, `shape RoundedRectangleBorder(rLg)`, `elevation 2`, `hoverElevation 4`, `focusElevation 4`, `sizeConstraints 56x56`, icon 24. Icon changes from `add_comment` to `edit_outlined`.
- `SnackBarThemeData`: `behavior floating`, `backgroundColor inverseSurface`, `contentTextStyle bodyMedium onInverseSurface`, `shape RoundedRectangleBorder(rMd)`, `elevation 0`, `insetPadding 16` all sides, `actionTextColor inversePrimary`. Duration 4 s. `showTranslatedSnackBar` passes `width: 400` when `MediaQuery.sizeOf(context).width >= 768`, otherwise no width (full width minus 16 margins).
- `DividerThemeData`: `color outlineVariant`, `thickness 1`, `space 1`.
- `ProgressIndicatorThemeData`: `color primary`, `strokeWidth 2.5`. Inside a filled button the indicator is 20x20 in `onPrimary`. `CircularIndicator` gains a `size` parameter (default 24) and a `color` override.
- `IconButtonThemeData`: default M3 standard icon button, 24 icon, 48x48 target; overlay `onSurface` 8 % hover, 12 % pressed.
- No `CardTheme`, `ListTileTheme` or `NavigationBar`: the screens use none.

## Layout rules

`PageContainer` becomes the only place that knows about the column:

- **Column width**: `kColumnWidthForm = 400`, `kColumnWidthFeed = 600`. `PageContainer` takes `columnWidth` (default 600). The body sits in `Center(child: ConstrainedBox(maxWidth: columnWidth))` with `Padding(horizontal: 16)` inside it. The horizontal gutter is a fixed 16, never a fraction of the viewport.
- **App bar aligns to the column.** `PageContainer` builds the app bar with `automaticallyImplyLeading: false`, `titleSpacing: 0` and a single `title` widget: the same `Center/ConstrainedBox(maxWidth: columnWidth)` holding a `Row` of [leading icon (48x48) if any, 8 gap, title text `Expanded`, actions]. So at 1280 the back arrow, `Home`, `X` and `Tweet` all sit on the column's edges, not the viewport's.
- **Leading icon**: back arrow (`Icons.arrow_back`, `MaterialLocalizations.backButtonTooltip`) when the route can pop. `PageContainer` gains `leadingStyle: PageLeading.back | PageLeading.close`; compose passes `close` (`Icons.close`, `closeButtonTooltip`). Both pop.
- **FAB aligns to the column.** `floatingActionButton` is wrapped in `Padding(right: max(0, (viewportWidth − columnWidth) / 2))` so it floats 16 inside the column's right edge at every width. Default location (`endFloat`), 16 from the bottom.

Per viewport (mobile-first; 390 is the base, the others only add):

| | 390 | 768 | 1280 |
| --- | --- | --- | --- |
| Auth forms | full width minus 16 gutters; heading 32 below the app bar / safe area | column 400 centred; same vertical rhythm | same as 768 |
| Home | list full width, dividers edge to edge | column 600 centred, 1px `outlineVariant` on its left and right edges running full height; dividers span the column | same; FAB at column edge |
| Compose | full width | column 600; text area fills the column | same |
| Snackbar | 16 margins | `width 400`, centred | same |
| Message views | content max width 320, centred | same | same |

Vertical rhythm on auth screens (from the top of the body): 32 → heading → 24 → email field → 16 → password field → (sign-up) 4 helper → 24 → inline error block if any → 16 → button → 16 → link row. On the keyboard opening the body scrolls (`SingleChildScrollView`, `keyboardDismissBehavior: onDrag`); the form is **top-aligned** (replaces the current `Center`) so it never jumps.

## Screens

### Entry `/` (auth index)

No app bar (unchanged). Three states, all `MessageView`-shaped, centred in the viewport:

- **Loading**: `CircularIndicator` 32x32 `primary` stroke 2.5, centred. Nothing else; it lasts well under a second.
- **Maintenance**: `MaintenanceView` reuses `MessageView` with `Icons.build_outlined` 40 in `onSurfaceVariant`, 16 gap, message `bodyLarge onSurface` centred, max width 320. No action (there is nothing to do but wait).
- **Error**: `Icons.cloud_off_outlined` 40 `onSurfaceVariant`, 16, message, 24, `FilledButton.tonal` `Try again` (48 high, hugs content, min width 120).

`MessageView` change: icon 40 (was 48) in `onSurfaceVariant` (was `outline`), message `bodyLarge`, gap to action 24 (was 16), `ConstrainedBox(maxWidth: 320)`.

The two transitional states (`Authorized`, `Unauthorized`) currently render a check / block icon for a frame; render the loading spinner instead so nothing flashes.

### Sign-in `/sign-in`

Purpose: get the returning user in. One primary action: `Sign in`.

Structure (390): no app bar (nothing to pop). Body column: heading `Welcome back` (`headlineMedium onSurface`, left-aligned), 24, email field, 16, password field, 24, `Sign in` filled button stretched to the column (`SizedBox(width: double.infinity)`), 16, centred link row: `Don't have an account?` (`bodyMedium onSurfaceVariant`) + 4 + `Create an account` (`TextButton`, `labelLarge primary`, underlined, 44 min height). Password field gets a visibility toggle (`Icons.visibility_outlined` / `visibility_off_outlined`, 48x48, tooltip from Material localizations `showPassword`/`hidePassword`? Those don't exist; use two new keys, see Copy).

States:

- **Idle**: as above. Email has `autofocus` (kept; the screen exists only to type). Field order email → password → `Sign in` (`textInputAction.next`, then `done` submits).
- **Validating**: `AutovalidateMode.onUserInteraction` (unchanged). A field with an error shows a 1px `error` border, floating label in `error`, message under it in `bodySmall error` (`Enter your email`, `Enter a valid email address`, `Enter your password`). The button stays enabled; pressing it re-validates and focuses the first invalid field.
- **Submitting**: fields read-only with `surfaceContainerHighest` fill, button disabled-looking but keeps `primary` bg with a 20x20 `onPrimary` spinner centred and the label hidden (`Semantics` reads `Signing in…`). The link row is hidden during submit (replaced by `SizedBox(height: 44)` to keep layout).
- **Wrong credentials** (`SignInUnauthorized`): **inline**, not a snackbar. An error block between the fields and the button: `errorContainer` bg, `rSm`, padding 12, `Icons.error_outline` 20 `onErrorContainer`, 8 gap, `Incorrect email or password.` in `bodyMedium onErrorContainer`, `Semantics(liveRegion: true)`. It stays until the next submit. The form keeps what was typed (unchanged behaviour); focus moves to the password field.
- **Unexpected error**: snackbar `Something went wrong. Please try again.`; form stays as it was.
- **Sign-up toggle off** (rule-driven): the link row is absent; the button is the last element. Drawn in the artboard.
- **Spanish**: `Hola de nuevo`, `Iniciar sesión`, `¿No tienes cuenta?` + `Crear una cuenta`. The link row wraps to two centred lines when it does not fit in the column (it fits at 390 in both languages at default text scale; at 1.3x it wraps).

### Sign-up `/sign-up`

Pushed over sign-in, so the app bar shows only the back arrow (48x48) and **no title**; the heading `Create your account` moves into the body, same rhythm as sign-in. Password field has helper text `At least 6 characters` (`bodySmall onSurfaceVariant`, new key). Primary action `Create account`, stretched. No link row.

States: idle, validating, submitting as sign-in. **Email in use** and **weak password** are inline blocks (same component as wrong credentials): `This email is already in use. Try signing in.` and `Use at least 6 characters.`; the weak-password block also focuses the password field. **Unexpected** is a snackbar.

### Home `/home`

Purpose: read the feed; post if you want. Primary action: the FAB.

App bar: `Home` in `titleLarge`, left, 16 from the column edge; no actions. Body: the feed. FAB 56 `edit_outlined`, tooltip `New tweet`.

**Feed row** (`TweetFeedListItem`), padding 16 all sides, `CrossAxisAlignment.start`:

- Avatar 40x40 circle, `surfaceContainerHighest` bg, first letter of the owner email upper-cased in `titleMedium onSurfaceVariant`, `ExcludeSemantics`. Replaces the generic person icon with something derived from data we already show.
- 12 gap. Column: header row = owner email `titleSmall onSurface` (`Expanded`, ellipsis) + ` · ` + time ago `bodySmall onSurfaceVariant` (no wrap, `maxLines 1`). 4 gap. Content `bodyLarge onSurface`, unlimited lines, soft-wrap; long content simply grows the row. 8 gap. Action row: like control.
- **Like control** (`TweetLikeButton`): `IconButton` with `padding: EdgeInsets.zero`, `constraints: BoxConstraints(minWidth: 44, minHeight: 44)`, `alignment: Alignment.centerLeft`, icon 20: `favorite_border` in `onSurfaceVariant`, selected `favorite` in `tertiary`. Count in `labelMedium`, 4 to the right of the glyph, `onSurfaceVariant` normally, `tertiary` when liked; **hidden when 0**. Row semantics: `Semantics(label: "<Like|Unlike>, <n>", toggled: likeIt, button: true)`. While sending: `onPressed` null but colours unchanged (the flip already happened optimistically; a grey flash would read as failure).
- Separator: `Divider` (1px `outlineVariant`, edge to edge). No divider above the first row or below the last.
- Web hover: row bg `surfaceContainer` (`InkWell` with no `onTap`, `hoverColor` only). No tap action on the row (there is no detail screen).

States:

- **Loading**: centred 32 spinner (as entry).
- **Found**: list, `ListView.separated`, bottom padding 88 so the FAB never covers the last like control.
- **Empty**: `MessageView` `Icons.chat_bubble_outline` 40, `No tweets yet. Be the first to post.`, no action (the FAB is the action, 16 above the bottom; the message sits in the vertical centre).
- **Error**: `Icons.cloud_off_outlined`, `We couldn't load the feed.`, tonal `Try again`.
- **Like failed**: snackbar (`Sign in again to like tweets.` / `We couldn't save your like.`) and the heart rolls back (existing).
- **Compose toggle off** (rule-driven): no FAB; list bottom padding drops to 16. Drawn.
- **Dark**: all roles from the dark column. Drawn.

### Compose `/tweet`

Purpose: write one tweet and send it. Primary action: `Tweet`.

App bar aligned to the column: leading `X` (close), no title text (the hint `What's happening?` says what the screen is; a `New tweet` title would duplicate it, but the route keeps `tweet_creation_feature.title` for the FAB tooltip and the web document title). Action: `Tweet` as a `FilledButton` pill (`shape StadiumBorder`, height 36, `padding h16`, `labelLarge`, `primary`/`onPrimary`), 16 from the column's right edge, vertically centred in the 56 bar. Replaces the check icon: a labelled button needs no tooltip to be understood.

Body: `TextField` with **no border** (`InputBorder.none`, `contentPadding 16 h, 12 v`), `bodyLarge`, `hintStyle bodyLarge onSurfaceVariant`, `autofocus`, `maxLines null`, `minLines 6`, `maxLength 280` with `buildCounter` returning the custom counter, `keyboardType multiline`, `textCapitalization sentences`. The field fills the column; the page scrolls when the text exceeds the viewport.

Counter: bottom-right under the text, 16 from the right, `bodySmall`. Reads `<remaining>` only (e.g. `280`, `12`): `onSurfaceVariant` until 20 remain, then `error` with weight 600; at 0 it reads `0` in `error`. Flutter already blocks the 281st character. `Semantics(label: "<remaining> characters left")` via a new key with `{n}` placeholder.

States:

- **Idle / empty**: `Tweet` disabled (`onSurface` 12 % bg, 38 % fg). Enabled as soon as the trimmed text is non-empty (the composer already trims; it now also drives the button's `onPressed` from `_controller` via a `ValueListenableBuilder`).
- **Typing**: counter counts down.
- **Near limit** (≤ 20 left): counter in `error`, 600 weight. Drawn.
- **Submitting**: field read-only, text `onSurfaceVariant`, the pill keeps its size and shows a 20x20 `onPrimary` spinner (`Semantics` `Posting your tweet…`), `X` disabled (`onSurface` 38 %).
- **Failed**: snackbar (`Sign in again to post.` / `We couldn't post your tweet. Please try again.`); draft kept (existing).
- **Posted**: route pops; the `TweetCreationTweeted` builder renders the same composer read-only for the single frame it exists instead of a check icon.

## Inline vs snackbar

Rule: a failure the user resolves **by changing what is on the screen** is inline, next to what they change; a failure they resolve **by trying again** or **cannot resolve** is a snackbar.

| Failure | Treatment | Why |
| --- | --- | --- |
| Field required / invalid | inline under the field | fixed by editing that field |
| Wrong email or password | inline block above the button | fixed by retyping; must stay readable while they retype, a 4 s toast cannot |
| Email already in use, weak password | inline block above the button | same; the weak-password one points at the password |
| Unexpected error on sign-in / sign-up | snackbar | not about the input; the form is untouched and `Sign in` is the retry |
| Session check failed, feed failed | message view with `Try again` | the whole screen has no content without it |
| Post failed (unauthenticated / unexpected) | snackbar | the draft is kept; `Tweet` is the retry |
| Like failed | snackbar | the control is inside a list; the heart rolling back is the inline signal |

Implementation hook: `EmailPasswordForm` gains `errorText: String?` (rendered as the block) and `passwordHelperText: String?`; `SignInComponent` / `SignUpComponent` pass `errorText` from the current state instead of showing a snackbar for those three states. Add `FormErrorMessage` to `application/widgets/forms/` as the block widget (used only by `EmailPasswordForm`, but defined once).

## Copy changes

Keys are unchanged. New keys are marked. Semantics strings not listed are kept.

| Key | en | es |
| --- | --- | --- |
| `maintenance_message` | We're doing some maintenance. Please try again later. | Estamos en mantenimiento. Vuelve a intentarlo más tarde. |
| `retry_button_title` | Try again | Reintentar |
| `form.email_required` | Enter your email | Ingresa tu email |
| `form.password_required` | Enter your password | Ingresa tu contraseña |
| `auth_index_feature.unexpected_message` | We couldn't check your session. | No pudimos comprobar tu sesión. |
| `sign_in_feature.title` **new** | Welcome back | Hola de nuevo |
| `sign_in_feature.unauthorized_message` | Incorrect email or password. | Email o contraseña incorrectos. |
| `sign_up_feature.button_prompt` **new** | Don't have an account? | ¿No tienes cuenta? |
| `sign_up_feature.button_title` | Create an account | Crear una cuenta |
| `sign_up_feature.submit_button_title` | Create account | Crear cuenta |
| `sign_up_feature.password_helper` **new** | At least 6 characters | Al menos 6 caracteres |
| `sign_up_feature.email_already_in_use` | This email is already in use. Try signing in. | Este email ya está en uso. Prueba a iniciar sesión. |
| `sign_up_feature.weak_password` | Use at least 6 characters. | Usa al menos 6 caracteres. |
| `form.show_password` **new** | Show password | Mostrar contraseña |
| `form.hide_password` **new** | Hide password | Ocultar contraseña |
| `tweet_feed_feature.empty_message` | No tweets yet. Be the first to post. | Aún no hay tweets. Publica el primero. |
| `tweet_feed_feature.unexpected_message` | We couldn't load the feed. | No pudimos cargar el feed. |
| `tweet_creation_feature.title` | New tweet | Nuevo tweet |
| `tweet_creation_feature.unexpected_error_message` | We couldn't post your tweet. Please try again. | No pudimos publicar tu tweet. Inténtalo de nuevo. |
| `tweet_creation_feature.counter_semantics` **new** | {n} characters left | Quedan {n} caracteres |
| `tweet_like_feature.unlike` | Unlike | Quitar me gusta |

Unchanged: `app_title`, labels (`Email`, `Password`), `sign_in_feature.submit_button_title`, `sign_up_feature.title`, `home_feature.title`, `hint_text`, `tweet_creation_feature.submit_button_title` (`Tweet` / `Twittear` is the product's verb), the `*_semantics` strings, `tweet_like_feature.like` and both `unauthenticated_message`s.

`{n}` is a plain `replaceAll('{n}', …)` in the widget; `I18n` does not need placeholders.

## Accessibility checklist

- Text contrast ≥ 4.5:1 on every pair used (table under Tokens); UI borders ≥ 3:1.
- Targets: FAB 56; app bar icons, field suffix icon 48; like control 44x44; text link 44 high; buttons 48 high; `Tweet` pill is 36 high visually inside a 48 hit area (`MaterialTapTargetSize.padded`).
- Focus order sign-in: email → password → show/hide password → `Sign in` → `Create an account`. Sign-up: email → password → show/hide → `Create account`; back arrow first. Compose: `X` → text → `Tweet`. Home: `Home` is a heading (`Semantics(header: true)`), rows in order, each like control focusable, FAB last.
- Icons that stand alone have labels: back / close (Material localizations), FAB (`New tweet`), like (`Like` / `Unlike` + count), show/hide password, spinner (`*_semantics` keys). Avatars are decorative (`ExcludeSemantics`).
- Inline error block is a live region; field errors are announced by Flutter's `TextFormField`.
- Text scale: layouts use `maxLines: null` for content and wrap the link row; nothing is clipped at 1.3x. Buttons grow with text (min height, not fixed).
- Dark mode uses the dark column; nothing is hard-coded.
- Reduced motion: none of the states animate beyond Flutter defaults.

## Out of scope

- Sign-out, profiles, display names, images, bottom navigation, pull-to-refresh, pagination, a detail screen.
- Short relative time (`3m`) instead of `3 minutes ago`: `timeago` ships `EnShortMessages`/`EsShortMessages`; a one-line adapter change if the owner wants Twitter-style stamps. The spec and artboard use the long form the app produces today.
- Password strength rules beyond the auth client's 6-character minimum.
- Web with Firebase (dev doc: not wired).

## What in the code limited the design

- `PageContainer` decides the app bar from `canPop || title || actions`; the column alignment and `close` leading need it to build the toolbar itself (`automaticallyImplyLeading: false`), which is the one structural change in the shell.
- `FeatureGate` renders `SizedBox.shrink()` when off, so the sign-in link and the FAB disappear without a trace; both states are drawn so the gap is deliberate.
- The inline errors require `EmailPasswordForm` to accept `errorText`; the cubit states already distinguish the three input failures, so no state changes are needed.
- `MessageView` is shared by entry, feed empty and feed error; the sizes above apply to all three.
- `Tweet` owner carries only `email`; the avatar initial and the owner line both derive from it (`tweet_feed` readme lists display names as a known gap).

## Artboard index

`ux-pass-1-artboard.html`, 390x844 unless noted: 01 entry loading · 02 entry maintenance · 03 entry error · 04 sign-in idle · 05 sign-in validating · 06 sign-in submitting · 07 sign-in wrong credentials · 08 sign-in unexpected snackbar · 09 sign-in sign-up off · 10 sign-in Spanish · 11 sign-up idle · 12 sign-up email in use · 13 home loading · 14 home feed · 15 home empty · 16 home error · 17 home like failed · 18 home compose off · 19 home dark · 20 compose empty · 21 compose near limit · 22 compose submitting · 23 compose failed · 24 home 768 · 25 home 1280 · 26 sign-in 1280.
