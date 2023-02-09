import "./style.css";
import { Elm } from "./src/Main.elm";


const app = Elm.Main.init({ flags: window });


let lastHash = location.hash;
const scrollToAnchor = () => {
    requestAnimationFrame(scrollToAnchor)
    if (!location.hash || lastHash === location.hash) return;
    document.querySelector(location.hash)?.scrollIntoView?.();
    lastHash = location.hash;
}
requestAnimationFrame(scrollToAnchor);