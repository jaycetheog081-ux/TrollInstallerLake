//
//  SettingsView.swift
//  TrollInstallerX
//
//  Created by Alfie on 26/03/2024.
//

import SwiftUI

struct SettingsView: View {

    let device: Device

    @AppStorage("exploitFlavour", store: TIXDefaults()) var exploitFlavour: String = ""
    @AppStorage("verbose", store: TIXDefaults()) var verbose: Bool = false

    // Human-readable label for the active PPL bypass
    var pplBypassLabel: String {
        if device.isArm64e {
            if device.isMomentariusDevice { return "momentarius (A12–A13)" }
            if titan.supports(device)     { return "titan" }
            if dmaFail.supports(device)   { return "dmaFail" }
            return "none"
        }
        return "n/a (arm64)"
    }

    var body: some View {
        VStack(spacing: 10) {
            Button(action: {
                UIImpactFeedbackGenerator().impactOccurred()
                let docsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                try? FileManager.default.removeItem(atPath: docsDir.path + "/kernelcache")
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(maxWidth: 225)
                        .frame(maxHeight: 40)
                        .foregroundColor(.white.opacity(0.2))
                        .shadow(radius: 10)
                    Text("Clear cached kernel")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .padding()
                }
            })
            .padding()

            if darksword.supports(device) || smith.supports(device) || physpuppet.supports(device) {
                Picker("Kernel exploit", selection: $exploitFlavour) {
                    if darksword.supports(device) {
                        Text("darksword").foregroundColor(.white).tag("darksword")
                    }
                    Text("landa").foregroundColor(.white).tag("landa")
                    if smith.supports(device) {
                        Text("smith").foregroundColor(.white).tag("smith")
                    }
                    if physpuppet.supports(device) {
                        Text("physpuppet").foregroundColor(.white).tag("physpuppet")
                    }
                }
                .pickerStyle(.segmented)
                .colorMultiply(.white)
                .padding()
            }

            // PPL bypass is auto-selected; show which one will be used
            if device.isArm64e {
                Text("PPL bypass: \(pplBypassLabel)")
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundColor(.white.opacity(0.6))
                    .padding(.horizontal)
            }

            VStack {
                Toggle(isOn: $verbose, label: {
                    Text("Verbose logging")
                        .font(.system(size: 17, weight: .regular, design: .rounded))
                        .foregroundColor(.white)
                })
            }
            .padding()
        }
        .onAppear {
            if exploitFlavour == "" {
                if darksword.supports(device) {
                    exploitFlavour = "darksword"
                } else if physpuppet.supports(device) {
                    exploitFlavour = "physpuppet"
                } else {
                    exploitFlavour = "landa"
                }
            }
        }
    }
}
