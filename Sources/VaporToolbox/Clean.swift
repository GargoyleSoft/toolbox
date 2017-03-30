import Console

public final class Clean: Command {
    public let id = "clean"

    public let signature: [Argument] = [
        Option(name: "xcode", help: ["Removes any Xcode projects while cleaning."]),
        Option(name: "pins", help: ["Removes the Package.pins file as well."])
    ]

    public let help: [String] = [
        "Cleans temporary files--usually fixes",
        "a plethora of bizarre build errors."
    ]

    public let console: ConsoleProtocol

    public init(console: ConsoleProtocol) {
        self.console = console
    }

    public func run(arguments: [String]) throws {
        let cleanBar = console.loadingBar(title: "Cleaning", animated: !arguments.isVerbose)
        cleanBar.start()

        _ = try console.backgroundExecute(program: "rm", arguments: ["-rf", ".build"])

        if arguments.flag("xcode") {
            _ = try console.backgroundExecute(program: "rm", arguments: ["-rf", "*.xcodeproj"])
        }

        if arguments.flag("pins") {
            _ = try console.backgroundExecute(program: "rm", arguments: ["-rf", "Package.pins"])
        }

        cleanBar.finish()
    }

}
