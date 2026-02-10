import { Astal } from "ags/gtk4"
import { createState, createBinding } from "ags"
import Apps from "gi://AstalApps"
import Gtk from "gi://Gtk"

export default function Launcher() {
    const apps = new Apps.Apps()
    const { TOP, LEFT, RIGHT, BOTTOM } = Astal.WindowAnchor

    const [query, setQuery] = createState("")
    const [results, setResults] = createState<Apps.Application[]>([])

    function search(text: string) {
        setQuery(text)
        const list = apps.fuzzy_query(text)
        setResults(list.slice(0, 8))
    }

    function launch(app: Apps.Application) {
        app.launch()
        const win = globalThis.app?.get_window("launcher")
        if (win) win.visible = false
        setQuery("")
        setResults([])
    }

    function onShow() {
        search("")
    }

    return (
        <window
            visible={false}
            class="launcher"
            name="launcher"
            anchor={TOP}
            exclusivity={Astal.Exclusivity.NORMAL}
            keymode={Astal.Keymode.ON_DEMAND}
            margin_top={120}
            onNotifyVisible={(self) => {
                if (self.visible) onShow()
            }}
            onKeyPressed={(self, keyval) => {
                if (keyval === 65307) { // Escape
                    self.visible = false
                }
            }}
        >
            <box class="launcher-box" vertical>
                <box class="launcher-search">
                    <label class="search-icon" label=" " />
                    <entry
                        class="search-entry"
                        placeholder_text="Search apps..."
                        onChanged={(self) => search(self.text || "")}
                        onActivate={() => {
                            const r = results()
                            if (r.length > 0) launch(r[0])
                        }}
                    />
                </box>
                <box class="launcher-results" vertical>
                    {results((list) =>
                        list.map((item) => (
                            <button
                                class="launcher-item"
                                onClicked={() => launch(item)}
                            >
                                <box>
                                    <image
                                        class="launcher-item-icon"
                                        iconName={createBinding(item, "iconName")}
                                        pixelSize={32}
                                    />
                                    <box vertical class="launcher-item-text">
                                        <label
                                            class="launcher-item-name"
                                            label={item.name || ""}
                                            halign={Gtk.Align.START}
                                        />
                                        <label
                                            class="launcher-item-desc"
                                            label={item.description || ""}
                                            halign={Gtk.Align.START}
                                            truncate
                                        />
                                    </box>
                                </box>
                            </button>
                        ))
                    )}
                </box>
            </box>
        </window>
    )
}
