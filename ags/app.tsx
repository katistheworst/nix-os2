import app from "ags/gtk4/app"
import { Astal } from "ags/gtk4"
import css from "./style.css"
import Bar from "./widgets/Bar"
import Launcher from "./widgets/Launcher"

app.start({
    css: css,
    main() {
        const { TOP, LEFT, RIGHT } = Astal.WindowAnchor
        Bar()
        Launcher()
    },
    requestHandler(request, respond) {
        if (request === "toggle-launcher") {
            const launcher = app.get_window("launcher")
            if (launcher) {
                launcher.visible = !launcher.visible
            }
            respond("ok")
        } else {
            respond("unknown command")
        }
    },
})
