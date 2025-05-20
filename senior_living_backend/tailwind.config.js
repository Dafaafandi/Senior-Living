// tailwind.config.js
import preset from "./vendor/filament/filament/tailwind.config.preset";

export default {
    presets: [preset],
    content: [
        "./app/Filament/**/*.php",
        "./resources/views/filament/**/*.blade.php",
        "./vendor/filament/**/*.blade.php",
        "./resources/views/**/*.blade.php",
    ],
    theme: {
        extend: {
            // Add any custom theme configurations here
        },
    },
    plugins: [],
};
