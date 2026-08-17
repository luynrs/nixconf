const browserColours = (colours) => ({
    bookmark_text: colours.onSurface,
    button_background_hover: colours.surfaceContainerHigh,
    button_background_active: colours.surfaceContainerHighest,
    icons: colours.secondary,
    icons_attention: colours.primary,
    frame: colours.surfaceDim,
    frame_inactive: colours.surfaceDim,
    tab_text: colours.onSurface,
    tab_loading: colours.primary,
    tab_background_text: colours.outline,
    tab_selected: colours.surfaceContainer,
    tab_line: colours.surfaceContainer,
    toolbar: colours.surfaceContainer,
    toolbar_text: colours.onSurface,
    toolbar_field: colours.surfaceBright,
    toolbar_field_focus: colours.surfaceBright,
    toolbar_field_border: colours.surfaceBright,
    toolbar_field_border_focus: colours.primary,
    toolbar_field_text: colours.onSurfaceVariant,
    toolbar_field_text_focus: colours.onSurface,
    toolbar_field_highlight: colours.primary,
    toolbar_field_highlight_text: colours.onPrimary,
    toolbar_field_separator: colours.surface,
    toolbar_top_separator: colours.surfaceContainer,
    toolbar_bottom_separator: colours.surface,
    toolbar_vertical_separator: colours.secondaryContainer,
    ntp_background: colours.surface,
    ntp_card_background: colours.surfaceContainer,
    ntp_text: colours.onSurface,
    popup: colours.surfaceContainer,
    popup_border: colours.outlineVariant,
    popup_text: colours.onSurface,
    popup_highlight: colours.primary,
    popup_highlight_text: colours.onPrimary,
    sidebar: colours.surfaceContainerHigh,
    sidebar_border: colours.surfaceContainerHigh,
    sidebar_text: colours.onSurface,
    sidebar_highlight: colours.secondaryContainer,
    sidebar_highlight_text: colours.onSecondaryContainer,
});

const darkReaderColours = (scheme) => ({
    mode: scheme.mode === "light" ? 0 : 1,
    [`${scheme.mode}SchemeTextColor`]: `#${scheme.colours.onSurface}`,
    [`${scheme.mode}SchemeBackgroundColor`]: `#${scheme.colours.surface}`,
});

let darkReader = browser.runtime.connect("addon@darkreader.org");
darkReader.onDisconnect.addListener(() => {
    console.log("DarkReader disconnected:", darkReader?.error);
    darkReader = null;
});

browser.runtime.connectNative("caelestiafox").onMessage.addListener((msg) => {
    console.log("Received message:", msg);

    const res = msg;
    const colours = Object.fromEntries(Object.entries(res.colours).map(([n, c]) => [n, `#${c}`]));
    const theme = {
        colors: browserColours(colours),
        properties: {
            color_scheme: res.mode,
            content_color_scheme: res.mode,
        },
    };
    browser.theme.update(theme);
    console.log("Theme updated:", theme);

    if (darkReader !== null) {
        darkReader.postMessage({ type: "setTheme", data: darkReaderColours(res) });
        console.log("DarkReader theme updated.");
    }
});

console.log("CaelestiaFox started.");
