import { Astal } from "ags/gtk4"
import { createBinding, createPoll } from "ags"
import Hyprland from "gi://AstalHyprland"
import Battery from "gi://AstalBattery"
import Wp from "gi://AstalWp"
import Network from "gi://AstalNetwork"
import Tray from "gi://AstalTray"
import GLib from "gi://GLib"

function Clock() {
    const time = createPoll("", 1000, () => {
        return GLib.DateTime.new_now_local().format("%H:%M")!
    })
    const date = createPoll("", 60000, () => {
        return GLib.DateTime.new_now_local().format("%A, %B %e")!
    })

    return (
        <box class="clock">
            <label class="clock-icon" label=" " />
            <label class="clock-time" label={time} />
        </box>
    )
}

function Workspaces() {
    const hypr = Hyprland.get_default()
    const workspaces = createBinding(hypr, "workspaces")
    const focused = createBinding(hypr, "focusedWorkspace")

    return (
        <box class="workspaces">
            {Array.from({ length: 9 }, (_, i) => {
                const id = i + 1
                const ws_class = focused((fw) => {
                    if (fw && fw.id === id) return "workspace active"
                    return "workspace"
                })

                return (
                    <button
                        class={ws_class}
                        onClicked={() => hypr.dispatch("workspace", String(id))}
                    >
                        <label label={String(id)} />
                    </button>
                )
            })}
        </box>
    )
}

function Volume() {
    const speaker = Wp.get_default()?.audio.defaultSpeaker!
    const vol = createBinding(speaker, "volume")
    const mute = createBinding(speaker, "mute")

    const icon = vol((v) => {
        const m = speaker.mute
        if (m) return "󰝟 "
        if (v > 0.66) return " "
        if (v > 0.33) return " "
        return " "
    })

    const label = vol((v) => `${Math.round(v * 100)}%`)

    return (
        <box class="volume module">
            <label class="module-icon" label={icon} />
            <label label={label} />
        </box>
    )
}

function NetworkIndicator() {
    const net = Network.get_default()
    const primary = createBinding(net, "primary")

    const icon = primary((p) => {
        if (p === Network.Primary.WIFI) {
            const wifi = net.wifi
            if (!wifi) return "󰖪 "
            const strength = wifi.strength
            if (strength > 80) return "󰤨 "
            if (strength > 60) return "󰤥 "
            if (strength > 40) return "󰤢 "
            return "󰤟 "
        }
        if (p === Network.Primary.WIRED) return "󰈀 "
        return "󰖪 "
    })

    return (
        <box class="network module">
            <label class="module-icon" label={icon} />
        </box>
    )
}

function BatteryIndicator() {
    const bat = Battery.get_default()
    const percentage = createBinding(bat, "percentage")
    const charging = createBinding(bat, "charging")

    const icon = percentage((p) => {
        const c = bat.charging
        if (c) return "⚡"
        const pct = Math.round(p * 100)
        if (pct > 90) return " "
        if (pct > 70) return " "
        if (pct > 50) return " "
        if (pct > 20) return " "
        return " "
    })

    const label = percentage((p) => `${Math.round(p * 100)}%`)

    return (
        <box class="battery module">
            <label class="module-icon" label={icon} />
            <label label={label} />
        </box>
    )
}

function SysTray() {
    const tray = Tray.get_default()
    const items = createBinding(tray, "items")

    return (
        <box class="systray">
            {items((list) =>
                list.map((item) => (
                    <menubutton
                        class="tray-item"
                        tooltipMarkup={createBinding(item, "tooltipMarkup")}
                        menuModel={createBinding(item, "menuModel")}
                    >
                        <image gicon={createBinding(item, "gicon")} />
                    </menubutton>
                ))
            )}
        </box>
    )
}

export default function Bar() {
    const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

    return (
        <window
            visible
            class="bar"
            name="bar"
            anchor={TOP | LEFT | RIGHT}
            exclusivity={Astal.Exclusivity.EXCLUSIVE}
            margin_top={6}
            margin_left={10}
            margin_right={10}
        >
            <centerbox>
                <box $type="start" class="bar-left">
                    <Workspaces />
                </box>
                <box $type="center" class="bar-center">
                    <Clock />
                </box>
                <box $type="end" class="bar-right">
                    <Volume />
                    <NetworkIndicator />
                    <BatteryIndicator />
                    <SysTray />
                </box>
            </centerbox>
        </window>
    )
}
