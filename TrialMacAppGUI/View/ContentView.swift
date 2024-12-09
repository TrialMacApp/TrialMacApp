//
//  ContentView.swift
//  TrialMacAppGUI
//
//  Created by TrialMacApp on 12/7/24.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("showAdminPrivilegeView") private var showAdminPrivilegeView: Bool = false
    @StateObject var localappManager: LocalAppManager = .shared
    @StateObject var supportedAppManager: SupportedAppManager = .shared
    
    @State private var isShowAllSupportedApp = false // sheet显示

    @State private var selectedApp: LocalAppInfo?
    @State private var searchText: String = ""

    var body: some View {
        NavigationSplitView {
            SidebarView(searchText: $searchText, selectedApp: $selectedApp)
                .environmentObject(localappManager)
        } detail: {
            if let app = selectedApp {
                AppDetailView(localAppInfo: app)
            } else {
                AboutView()
            }
        }
        .toolbar {
            toolbarContent
        }
        .sheet(isPresented: $isShowAllSupportedApp) {
            SupportedAppView()
                .environmentObject(supportedAppManager)
        }
        .sheet(isPresented: $showAdminPrivilegeView) {
            AdminPrivilegeView()
        }
        .searchable(text: $searchText, placement: .sidebar)
        .navigationTitle(selectedApp != nil ? "App Details" : "TrialMacAppGUI")
    }

    // 功能合集
    private var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .automatic) {
            Button {
                let windowController = UpdateLogWindowController()
                windowController.show()
            } label: {
                Label("Update Logs", systemImage: "info.bubble.rtl")
            }
            
            Button {
                showAdminPrivilegeView = true
            } label: {
                Label("Enter password again", systemImage: "lock")
            }

            Button {
                localappManager.loadData()
                selectedApp = nil
                searchText = ""
            } label: {
                Label("Refresh app list", systemImage: "arrow.clockwise")
            }

            Button {
                isShowAllSupportedApp.toggle()
            } label: {
                Label("Supported apps", systemImage: "list.clipboard")
            }
        }
    }
}
