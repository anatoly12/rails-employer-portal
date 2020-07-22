const purgecss = require('@fullhuman/postcss-purgecss');
module.exports = (env, _args) => {
  return {
    plugins: [
      require('postcss-import'),
      require('postcss-flexbugs-fixes'),
      require('tailwindcss')('./app/javascript/stylesheets/tailwind.config.js'),
      require('autoprefixer'),
      require('postcss-preset-env')({
        autoprefixer: {
          flexbox: 'no-2009'
        },
        stage: 3
      }),
      ...process.env.NODE_ENV === 'production' ? [purgecss({
        content: env.file.basename=='admin.scss' ? [
          './app/helpers/*.rb',
          './app/views/**/*.html.erb',
          './app/javascript/application/*.js',
          './app/javascript/admin/*.js',
        ] : [
          './app/helpers/!(admin)*.rb',
          './app/views/!(admin)/*.html.erb',
          './app/javascript/application/*.js',
        ],
        defaultExtractor: content => {
          // Capture as liberally as possible, including things like `h-(screen-1.5)`
          const broadMatches = content.match(/[^<>"'`\s]*[^<>"'`\s:]/g) || []
          // Capture classes within other delimiters like .block(class="w-1/2") in Pug
          const innerMatches = content.match(/[^<>"'`\s.()]*[^<>"'`\s.():]/g) || []
          return broadMatches.concat(innerMatches)
        }
      })] : []
    ]
  };
}
