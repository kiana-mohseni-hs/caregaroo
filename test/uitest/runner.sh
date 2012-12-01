USAGE="Usage: '$0' [-s spec file|spec dir] [-u url]"
URL=http://cg2-staging.herokuapp.com
SPEC=tests/suites
PHANTOMJS_EXECUTABLE=lib/phantomjs-macosx/bin/phantomjs
CASPERJS_BOOTSTRAP=lib/casperjs/bin/bootstrap.js

# Parse command line options
while getopts hs:u: OPT; do
  case "$OPT" in
    h)
      echo $USAGE
      exit 0
      ;;
    s)
      SPEC=$OPTARG
      ;;
    u)
      URL=$OPTARG
      ;;
    \?)
      # handle errors
      echo $USAGE >&2
      exit 1
      ;;
  esac
done

# Remove the options we parsed above
shift `expr $OPTIND - 1`

# Error if there are arguments without a switch
if [ $# -gt 0 ]; then
  echo $USAGE >&2
  exit 1
fi

./$PHANTOMJS_EXECUTABLE $CASPERJS_BOOTSTRAP \
  --casper-path=lib/casperjs \
  --cli \
  --xunit=results.xml \
  --log-level=debug \
  --direct=true \
  --url=$URL \
  tests/caregaroorunner.js $SPEC \
  --includes=tests/includes/StringUtilities.js \
  --pre=tests/suites/pre/generatetestnetworks.js