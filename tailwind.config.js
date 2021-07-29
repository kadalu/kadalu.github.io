module.exports = {
    mode: 'jit',
    purge: [
        './layouts/**/*.html',
        './content/**/*.html',
        './content/**/*.erb',
        './content/**/*.md',
        './content/**/*.adoc'
    ],
    darkMode: false, // or 'media' or 'class'
    variants: {
        extend: {},
    },
    theme: {
        extend: {
            typography: (theme) => ({
                DEFAULT: {
                    css: {
                        pre: {
                            color: theme("colors.gray.900"),
                            backgroundColor: '#f3f6fa'
                        },
                        "pre code::before": {
                            "padding-left": "unset"
                        },
                        "pre code::after": {
                            "padding-right": "unset"
                        },
                        code: {
                            backgroundColor: '#f3f6fa',
                            color: "#DD1144",
                            fontWeight: "400",
                            "border-radius": "0.25rem"
                        },
                        "code::before": {
                            content: '""',
                            "padding-left": "0.25rem"
                        },
                        "code::after": {
                            content: '""',
                            "padding-right": "0.25rem"
                        }
                    }
                }
            })
        }
    },
    plugins: [require("@tailwindcss/typography")],
}
