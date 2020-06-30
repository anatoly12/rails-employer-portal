module.exports = {
  purge: [
    './app/helpers/*.rb',
    './app/views/**/*.html.erb',
    './app/javascript/application/*.js',
    './app/javascript/admin/*.js',
    './app/javascript/styleshets/*.scss',
  ],
  theme: {
    extend: {},
  },
  variants: {
    borderColor: ['responsive', 'hover', 'focus', 'last'],
  },
  plugins: [],
}
