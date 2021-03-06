#
# Common variables
#

# Baikal version
VERSION=0.4.6

# Baikal source archive checksum
BAIKAL_SOURCE_SHA256="946e8e4161f7ef84be42430b6e9d3bb7dd4bbbe241b409be208c14447d7aa7a6"

# Remote URL to fetch Baikal source archive
BAIKAL_SOURCE_URL="https://github.com/fruux/Baikal/releases/download/${VERSION}/baikal-${VERSION}.zip"

# App package root directory should be the parent folder
PKGDIR=$(cd ../; pwd)

#
# Common helpers
#

# Source app helpers
source /usr/share/yunohost/helpers

# Download and extract Baikal sources to the given directory
# usage: extract_baikal DESTDIR
extract_baikal() {
  local DESTDIR=$1
  local bk_archive="${DESTDIR}/baikal.zip"

  wget -q -O "$bk_archive" "$BAIKAL_SOURCE_URL" \
    || ynh_die "Unable to download Baikal archive"
  echo "$BAIKAL_SOURCE_SHA256 $bk_archive" | sha256sum -c >/dev/null \
    || ynh_die "Invalid checksum of downloaded archive"
  unzip -q "$bk_archive" -d "$DESTDIR" \
    || ynh_die "Unable to extract Baikal archive"
  mv "${DESTDIR}/baikal/"* "$DESTDIR"
  rm -rf "$bk_archive" "${DESTDIR}/baikal"

  # apply patches
  (cd "$DESTDIR" \
   && for p in ${PKGDIR}/patches/*.patch; do patch -p1 < $p; done) \
    || die "Unable to apply patches to Baikal"
}
