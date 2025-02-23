{ stdenv
, lib
, fetchFromGitHub
, cmake
, qttools
, pkg-config
, qtbase
, wrapQtAppsHook
, dtkwidget
, qt5integration
, qt5platform-plugins
, libuuid
, parted
, partclone
}:

stdenv.mkDerivation rec {
  pname = "deepin-clone";
  version = "5.0.11";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-ZOJc8R82R9q87Qpf/J4CXE+xL6nvbsXRIs0boNY+2uk=";
  };

  postPatch = ''
    substituteInPlace app/{deepin-clone-ionice,deepin-clone-pkexec,deepin-clone.desktop,com.deepin.pkexec.deepin-clone.policy.tmp} \
      --replace "/usr" "$out"

    substituteInPlace app/src/corelib/ddevicediskinfo.cpp \
      --replace "/sbin/blkid" "${libuuid}/bin/blkid"

    substituteInPlace app/src/corelib/helper.cpp \
      --replace "/bin/lsblk" "${libuuid}/bin/lsblk" \
      --replace "/sbin/sfdisk" "${libuuid}/bin/sfdisk" \
      --replace "/sbin/partprobe" "${parted}/bin/partprobe" \
      --replace "/usr/sbin" "${partclone}/bin"
  '';

  nativeBuildInputs = [
    cmake
    qttools
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    dtkwidget
    qt5platform-plugins
    libuuid
    parted
    partclone
  ];

  cmakeFlags = [
    "-DDISABLE_DFM_PLUGIN=YES"
  ];

  strictDeps = true;

  # qt5integration must be placed before qtsvg in QT_PLUGIN_PATH
  qtWrapperArgs = [
    "--prefix QT_PLUGIN_PATH : ${qt5integration}/${qtbase.qtPluginPrefix}"
  ];

  meta = with lib; {
    description = "Disk and partition backup/restore tool";
    homepage = "https://github.com/linuxdeepin/deepin-clone";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}

