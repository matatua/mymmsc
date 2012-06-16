/**
 * 
 */
package org.mymmsc.app.hengxin.apk;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.logging.ConsoleHandler;
import java.util.logging.Formatter;
import java.util.logging.Handler;
import java.util.logging.Level;
import java.util.logging.LogRecord;
import java.util.logging.Logger;

import brut.androlib.Androlib;
import brut.androlib.AndrolibException;
import brut.androlib.ApkDecoder;
import brut.androlib.err.CantFindFrameworkResException;
import brut.androlib.err.InFileNotFoundException;
import brut.androlib.err.OutDirExistsException;

/**
 * @author wangfeng
 * 
 */
public class ApkToolTmp {

	public static void main(String[] args) throws IOException,
			AndrolibException, InterruptedException {
		try {
			Verbosity verbosity = Verbosity.NORMAL;
			int i = 0;
			for (i = 0; i < args.length; ++i) {
				String opt = args[i];
				if (!(opt.startsWith("-"))) {
					break;
				}
				if (("-v".equals(opt)) || ("--verbose".equals(opt))) {
					if (verbosity != Verbosity.NORMAL) {
						throw new InvalidArgsError();
					}
					verbosity = Verbosity.VERBOSE;
				} else if (("-q".equals(opt)) || ("--quiet".equals(opt))) {
					if (verbosity != Verbosity.NORMAL) {
						throw new InvalidArgsError();
					}
					verbosity = Verbosity.QUIET;
				} else {
					throw new InvalidArgsError();
				}
			}
			setupLogging(verbosity);

			if (args.length <= i) {
				throw new InvalidArgsError();
			}
			String cmd = args[i];
			args = (String[]) Arrays.copyOfRange(args, i + 1, args.length);
			if (("d".equals(cmd)) || ("decode".equals(cmd)))
				cmdDecode(args);
			else if (("b".equals(cmd)) || ("build".equals(cmd)))
				cmdBuild(args);
			else if (("if".equals(cmd)) || ("install-framework".equals(cmd)))
				cmdInstallFramework(args);
			else if ("publicize-resources".equals(cmd))
				cmdPublicizeResources(args);
			else
				throw new InvalidArgsError();
		} catch (InvalidArgsError ex) {
			usage();
			System.exit(1);
		}
	}

	private static void cmdDecode(String[] args)
			throws ApkToolTmp.InvalidArgsError, AndrolibException {
		ApkDecoder decoder = new ApkDecoder();
		int i = 0;
		for (i = 0; i < args.length; ++i) {
			String opt = args[i];
			if (!(opt.startsWith("-"))) {
				break;
			}
			if (("-s".equals(opt)) || ("--no-src".equals(opt))) {
				decoder.setDecodeSources((short) 0);
			} else if (("-d".equals(opt)) || ("--debug".equals(opt))) {
				decoder.setDebugMode(true);
			} else if (("-t".equals(opt)) || ("--frame-tag".equals(opt))) {
				++i;
				if (i >= args.length) {
					throw new ApkToolTmp.InvalidArgsError();
				}
				decoder.setFrameworkTag(args[i]);
			} else if (("-f".equals(opt)) || ("--force".equals(opt))) {
				decoder.setForceDelete(true);
			} else if (("-r".equals(opt)) || ("--no-res".equals(opt))) {
				decoder.setDecodeResources((short) 256);
			} else if ("--keep-broken-res".equals(opt)) {
				decoder.setKeepBrokenResources(true);
			} else {
				throw new ApkToolTmp.InvalidArgsError();
			}
		}

		String outName = null;
		if (args.length == i + 2) {
			outName = args[(i + 1)];
		} else if (args.length == i + 1) {
			outName = args[i];
			outName = outName + ".out";

			outName = new File(outName).getName();
		} else {
			throw new ApkToolTmp.InvalidArgsError();
		}
		File outDir = new File(outName);
		decoder.setOutDir(outDir);
		decoder.setApkFile(new File(args[i]));
		try {
			decoder.decode();
		} catch (OutDirExistsException ex) {
			System.out
					.println("Destination directory ("
							+ outDir.getAbsolutePath()
							+ ") "
							+ "already exists. Use -f switch if you want to overwrite it.");

			System.exit(1);
		} catch (InFileNotFoundException ex) {
			System.out.println("Input file (" + args[i] + ") "
					+ "was not found or was not readable.");

			System.exit(1);
		} catch (CantFindFrameworkResException ex) {
			System.out
					.println("Can't find framework resources for package of id: "
							+ String.valueOf(ex.getPkgId())
							+ ". You must install proper "
							+ "framework files, see project website for more info.");

			System.exit(1);
		}
	}

	private static void cmdBuild(String[] args)
			throws ApkToolTmp.InvalidArgsError, AndrolibException {
		boolean forceBuildAll = false;
		boolean debug = false;
		int i = 0;
		for (i = 0; i < args.length; ++i) {
			String opt = args[i];
			if (!(opt.startsWith("-"))) {
				break;
			}
			if (("-f".equals(opt)) || ("--force-all".equals(opt)))
				forceBuildAll = true;
			else if (("-d".equals(opt)) || ("--debug".equals(opt)))
				debug = true;
			else {
				throw new ApkToolTmp.InvalidArgsError();
			}

		}

		File outFile = null;
		String appDirName;
		switch (args.length - i) {
		case 0:
			appDirName = ".";
			break;
		case 2:
			outFile = new File(args[(i + 1)]);
		case 1:
			appDirName = args[i];
			break;
		default:
			throw new ApkToolTmp.InvalidArgsError();
		}

		new Androlib().build(new File(appDirName), outFile, forceBuildAll,
				debug);
	}

	private static void cmdInstallFramework(String[] args)
			throws AndrolibException {
		String tag = null;
		switch (args.length) {
		case 2:
			tag = args[1];
		case 1:
			new Androlib().installFramework(new File(args[0]), tag);
			return;
		}

		throw new ApkToolTmp.InvalidArgsError();
	}

	private static void cmdPublicizeResources(String[] args)
			throws ApkToolTmp.InvalidArgsError, AndrolibException {
		if (args.length != 1) {
			throw new ApkToolTmp.InvalidArgsError();
		}

		new Androlib().publicizeResources(new File(args[0]));
	}

	private static void usage() {
		System.out
				.println("Apktool v"
						+ Androlib.getVersion()
						+ " - a tool for reengineering Android apk files\n"
						+ "Copyright 2010 Ryszard Wiśniewski <brut.alll@gmail.com>\n"
						+ "Apache License 2.0 (http://www.apache.org/licenses/LICENSE-2.0)\n"
						+ "\n"
						+ "Usage: apktool [-q|--quiet OR -v|--verbose] COMMAND [...]\n"
						+ "\n"
						+ "COMMANDs are:\n"
						+ "\n"
						+ "    d[ecode] [OPTS] <file.apk> [<dir>]\n"
						+ "        Decode <file.apk> to <dir>.\n"
						+ "\n"
						+ "        OPTS:\n"
						+ "\n"
						+ "        -s, --no-src\n"
						+ "            Do not decode sources.\n"
						+ "        -r, --no-res\n"
						+ "            Do not decode resources.\n"
						+ "        -d, --debug\n"
						+ "            Decode in debug mode. Check project page for more info.\n"
						+ "        -f, --force\n"
						+ "            Force delete destination directory.\n"
						+ "        -t <tag>, --frame-tag <tag>\n"
						+ "            Try to use framework files tagged by <tag>.\n"
						+ "        --keep-broken-res\n"
						+ "            Use if there was an error and some resources were dropped, e.g.:\n"
						+ "            \"Invalid config flags detected. Dropping resources\", but you\n"
						+ "            want to decode them anyway, even with errors. You will have to\n"
						+ "            fix them manually before building."
						+ "\n"
						+ "    b[uild] [OPTS] [<app_path>] [<out_file>]\n"
						+ "        Build an apk from already decoded application located in <app_path>.\n"
						+ "\n"
						+ "        It will automatically detect, whether files was changed and perform\n"
						+ "        needed steps only.\n"
						+ "\n"
						+ "        If you omit <app_path> then current directory will be used.\n"
						+ "        If you omit <out_file> then <app_path>/dist/<name_of_original.apk>\n"
						+ "        will be used.\n"
						+ "\n"
						+ "        OPTS:\n"
						+ "\n"
						+ "        -f, --force-all\n"
						+ "            Skip changes detection and build all files.\n"
						+ "        -d, --debug\n"
						+ "            Build in debug mode. Check project page for more info.\n"
						+ "\n"
						+ "    if|install-framework <framework.apk> [<tag>]\n"
						+ "        Install framework file to your system.\n"
						+ "\n"
						+ "For additional info, see: http://code.google.com/p/android-apktool/");
	}

	private static void setupLogging(Verbosity verbosity) {
		Logger logger = Logger.getLogger("");
		for (Handler handler : logger.getHandlers()) {
			logger.removeHandler(handler);
		}
		if (verbosity == Verbosity.QUIET) {
			return;
		}

		Handler handler = new ConsoleHandler();
		logger.addHandler(handler);

		if (verbosity == Verbosity.VERBOSE) {
			handler.setLevel(Level.ALL);
			logger.setLevel(Level.ALL);
		} else {
			handler.setFormatter(new Formatter() {
				public String format(LogRecord record) {
					return record.getLevel().toString().charAt(0) + ": "
							+ record.getMessage()
							+ System.getProperty("line.separator");
				}
			});
		}
	}

	static class InvalidArgsError extends AndrolibException {
		private static final long serialVersionUID = 1L;
	}

	private static enum Verbosity {
		NORMAL, VERBOSE, QUIET;
	}
}