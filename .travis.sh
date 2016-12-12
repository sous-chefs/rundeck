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
  echo unknown suite
  exit 1
  ;;
esac
