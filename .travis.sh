set -ev

case $SUITE in
chefspec)
  rspec
  ;;
lint)
  foodcritic --context --progress .
  rubocop --lint --display-style-guide --extra-details --display-cop-names
  ;;
*)
  rake integration:docker[test,"$SUITE",2]
  ;;
esac
