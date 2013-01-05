# Determine if we are Windows (Cygwin)
KERNEL=`uname -s`
if [ $KERNEL == "CYGWIN_NT-6.1-WOW64" ]; then
    PHANTOMJS_EXECUTABLE=lib/phantomjs-win/phantomjs.exe
else
    PHANTOMJS_EXECUTABLE=lib/phantomjs-macosx/bin/phantomjs
fi

# Define default variables
CASPERJS_BOOTSTRAP=lib/casperjs/bin/bootstrap.js
URL=http://cg2-staging.herokuapp.com
SPEC=tests/suites
PRE=tests/pre/generatetestnetworks.js

USAGE="Usage: $0 [options]\n\nwhere options include:\n
\t-l\tFlag to load the networks data from disk.\n
\t\tDefault: off\n
\t-s [<directory> | <spec>]\n
\t\tPath to a directory of specs or path to a spec file.\n
\t\tDefault: '$SPEC'.\n
\t-u [<url>]\n
\t\tURL of the application to test.\n
\t\tDefault: $URL."

# Parse command line options
while getopts hls:u: OPT; do
  case "$OPT" in
    h)
      echo -e $USAGE
      exit 0
      ;;
    l)
      PRE=tests/pre/loadtestnetworksfromdisk.js
      ;;
    s)
      SPEC=$OPTARG
      ;;
    u)
      URL=$OPTARG
      ;;
    \?)
      # handle errors
      echo -e $USAGE >&2
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
  --pre=$PRE
