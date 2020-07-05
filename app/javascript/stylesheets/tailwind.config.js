module.exports = {
  purge: [
    './app/helpers/*.rb',
    './app/views/**/*.html.erb',
    './app/javascript/application/*.js',
    './app/javascript/admin/*.js',
    './app/javascript/styleshets/*.scss',
  ],
  theme: {
    extend: {
      spacing: {
        '14': '3.5rem',
        '28': '7rem',
        '36': '9rem',
        '40': '10rem',
        '52': '13rem',
      },
    },
  },
  variants: {
    borderColor: ['responsive', 'hover', 'focus', 'last'],
    borderWidth: ['responsive', 'hover'],
  },
  plugins: [],
}
