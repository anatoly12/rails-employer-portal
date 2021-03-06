module.exports = {
  purge: false,
  theme: {
    extend: {
      spacing: {
        '14': '3.5rem',
        '28': '7rem',
        '36': '9rem',
        '40': '10rem',
        '52': '13rem',
      },
      screens: {
        '2xl': '1860px',
        '3xl': '2560px',
      },
      zIndex: {
        '-10': '-10',
      },
    },
  },
  variants: {
    borderColor: ['responsive', 'hover', 'focus', 'last'],
    borderWidth: ['responsive', 'hover'],
  },
  plugins: [],
}
