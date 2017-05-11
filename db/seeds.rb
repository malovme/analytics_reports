# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
metrics = [
    ['ga:sessions', 'Sessions'],
    ['ga:pageviews', 'Pageviews'],
    ['ga:sessionDuration', 'Session Duration'],
    ['ga:bounces', 'Bounces'],
    ['ga:exits', 'Exits'],
    ['ga:uniquePageviews', 'Unique Pageviews'],
    ['ga:timeOnPage', 'Time on Page'],
    ['ga:entrances', 'Entrances'],
    ['ga:searchUniques', 'Total Unique Searches']
]
metrics.each do |value, name|
  Metric.create(name: name, value: value)
end

dimensions = [
    ['ga:mobileDeviceInfo', 'Mobile Device Info'],
    ['ga:source', 'Source'],
    ['ga:medium', 'Medium'],
    ['ga:userType', 'User Type'],
    ['ga:country', 'Country'],
    ['ga:operatingSystem', 'Operating System'],
    ['ga:operatingSystemVersion', 'Operating System Version'],
    ['ga:browser', 'Browser'],
    ['ga:browserVersion', 'Browser Version'],
    ['ga:keyword', 'Keyword'],
    ['ga:pagePath', 'Page'],
    ['ga:landingPagePath', 'Landing Page'],
    ['ga:exitPagePath', 'Exit Page'],
    ['ga:searchKeyword', 'Search Term']
]
dimensions.each do |value, name|
  Dimension.create(name: name, value: value)
end
