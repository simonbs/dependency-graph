enum ClusterName {
    static func project(_ string: String) -> String {
        return "project_" + string.safeName
    }

    static func package(_ string: String) -> String {
        return "package_" + string.safeName
    }
}
