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
  KITCHEN_LOCAL_YAML='.kitchen.docker.yml' kitchen test "$SUITE" --concurrency=2 --log-level=debug
  ;;
esac
