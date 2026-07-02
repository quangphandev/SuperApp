//
//  FloatingPIPView.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 12/06/26.
//

import UIKit
import SnapKit

final class FloatingPIPView: UIView {

    // MARK: - UI Components

    private let accentGlowView = UIView()
    private let livePulseView = UIView()
    private let liveDotView = UIView()
    private let liveLabel = UILabel()
    private let closeButton = UIButton()
    private let openButton = UIButton()
    private let subtitleLabel = UILabel()
    private let timeLabel = UILabel()
    private let escalationPillView = UIView()
    private let escalationLabel = UILabel()
    private let progressTrackView = UIView()
    private let progressFillView = UIView()

    // MARK: - Properties

    private var countdownSeconds = 491 // 8m 11s
    private let totalSeconds = 600
    private var timer: Timer?

    var onCloseTap: (() -> Void)?
    var onOpenTap: (() -> Void)?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        setupActions()
        updateUI()
        startPulseAnimation()
        startTimer()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        timer?.invalidate()
    }

    // MARK: - Setup

    private func setupViews() {
        backgroundColor = UIColor(hex: "#0D1B1F").withAlphaComponent(0.98)
        layer.cornerRadius = 22
        layer.borderWidth = 1.5
        layer.borderColor = TimerColor.accent.cgColor

        // Shadow
        layer.shadowColor = TimerColor.accent.cgColor
        layer.shadowOpacity = 0.18
        layer.shadowOffset = CGSize(width: 0, height: 12)
        layer.shadowRadius = 28
        layer.masksToBounds = false

        // Accent Glow Background (inset by 10)
        accentGlowView.backgroundColor = UIColor(hex: "#071821").withAlphaComponent(0.34)
        accentGlowView.layer.cornerRadius = 18
        addSubview(accentGlowView)

        // Live pulse and dot
        livePulseView.backgroundColor = TimerColor.accent.withAlphaComponent(0.18)
        livePulseView.layer.cornerRadius = 7
        addSubview(livePulseView)

        liveDotView.backgroundColor = TimerColor.accent
        liveDotView.layer.cornerRadius = 3
        livePulseView.addSubview(liveDotView)

        // Live Label
        liveLabel.text = "LIVE · Timer chạy"
        liveLabel.font = AppFont.font(size: 10, weight: .semibold)
        liveLabel.textColor = UIColor(hex: "#7EEBFF")
        addSubview(liveLabel)

        // Actions
        closeButton.setTitle("×", for: .normal)
        closeButton.setTitleColor(UIColor(hex: "#CBE2D6"), for: .normal)
        closeButton.titleLabel?.font = AppFont.font(size: 16, weight: .semibold)
        addSubview(closeButton)

        openButton.setTitle("↗", for: .normal)
        openButton.setTitleColor(UIColor(hex: "#CBE2D6"), for: .normal)
        openButton.titleLabel?.font = AppFont.font(size: 14, weight: .semibold)
        addSubview(openButton)

        // Subtitle
        subtitleLabel.text = "Sale 20:00 · Voucher 50%"
        subtitleLabel.font = AppFont.font(size: 11, weight: .medium)
        subtitleLabel.textColor = UIColor(hex: "#8DA096")
        subtitleLabel.textAlignment = .center
        addSubview(subtitleLabel)

        // Time
        timeLabel.text = "00:08:11"
        timeLabel.font = AppFont.font(size: 31, weight: .bold)
        timeLabel.textColor = UIColor(hex: "#F4F7F3")
        timeLabel.textAlignment = .center
        addSubview(timeLabel)

        // Escalation Pill
        escalationPillView.backgroundColor = UIColor(hex: "#183629")
        escalationPillView.layer.cornerRadius = 10
        escalationPillView.layer.borderWidth = 1
        escalationPillView.layer.borderColor = UIColor(hex: "#2E5A46").cgColor
        addSubview(escalationPillView)

        escalationLabel.text = "đang chạy · T-60s"
        escalationLabel.font = AppFont.font(size: 9, weight: .semibold)
        escalationLabel.textColor = TimerColor.accent
        escalationLabel.textAlignment = .center
        escalationPillView.addSubview(escalationLabel)

        // Progress bar
        progressTrackView.backgroundColor = UIColor(hex: "#183629")
        progressTrackView.layer.cornerRadius = 2
        addSubview(progressTrackView)

        progressFillView.backgroundColor = TimerColor.accent
        progressFillView.layer.cornerRadius = 2
        progressTrackView.addSubview(progressFillView)
    }

    private func setupConstraints() {
        accentGlowView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }

        livePulseView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(17)
            make.size.equalTo(14)
        }

        liveDotView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(6)
        }

        liveLabel.snp.makeConstraints { make in
            make.leading.equalTo(livePulseView.snp.trailing).offset(3)
            make.centerY.equalTo(livePulseView)
        }

        openButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalTo(livePulseView)
            make.size.equalTo(24)
        }

        closeButton.snp.makeConstraints { make in
            make.trailing.equalTo(openButton.snp.leading).offset(-4)
            make.centerY.equalTo(livePulseView)
            make.size.equalTo(24)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(36)
            make.leading.trailing.equalToSuperview().inset(10)
        }

        timeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(53)
            make.leading.trailing.equalToSuperview()
        }

        escalationPillView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(91)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(20)
        }

        escalationLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        progressTrackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-8)
            make.height.equalTo(4)
        }

        progressFillView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.72)
        }
    }

    private func setupActions() {
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        openButton.addTarget(self, action: #selector(didTapOpen), for: .touchUpInside)
    }

    // MARK: - Configure

    func configure(
        title: String,
        subtitle: String,
        time: String,
        badge: String,
        tone: TimerTone
    ) {
        liveLabel.text = title
        subtitleLabel.text = subtitle
        if let parsedSeconds = parseTime(time) {
            countdownSeconds = parsedSeconds
        }
        escalationLabel.text = badge
        updateUI()
    }

    // MARK: - Actions

    @objc private func didTapClose() {
        AppAnimation.haptic(.light)
        onCloseTap?()
    }

    @objc private func didTapOpen() {
        AppAnimation.haptic(.light)
        onOpenTap?()
    }

    // MARK: - Timer Logic

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }

    private func tick() {
        if countdownSeconds > 0 {
            countdownSeconds -= 1
            updateUI()

            if countdownSeconds <= 10 {
                flashBorder(color: TimerColor.danger)
                triggerHaptic()
            } else if countdownSeconds <= 60 {
                flashBorder(color: TimerColor.accent)
            }
        } else {
            timer?.invalidate()
            timeLabel.text = "00:00:00"
            updateProgress(ratio: 1.0)
            escalationLabel.text = "Đã diễn ra"
            layer.borderColor = TimerColor.danger.cgColor
            flashBorder(color: TimerColor.danger)
        }
    }

    private func updateUI() {
        let hours = countdownSeconds / 3600
        let minutes = (countdownSeconds % 3600) / 60
        let seconds = countdownSeconds % 60
        timeLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)

        let ratio = CGFloat(totalSeconds - countdownSeconds) / CGFloat(totalSeconds)
        updateProgress(ratio: ratio)

        if countdownSeconds <= 10 {
            escalationLabel.text = "đang chạy · T-10s"
            escalationPillView.backgroundColor = TimerColor.danger.withAlphaComponent(0.2)
            escalationPillView.layer.borderColor = TimerColor.danger.cgColor
            escalationLabel.textColor = TimerColor.danger
        } else if countdownSeconds <= 60 {
            escalationLabel.text = "đang chạy · T-60s"
            escalationPillView.backgroundColor = UIColor(hex: "#183629")
            escalationPillView.layer.borderColor = UIColor(hex: "#2E5A46").cgColor
            escalationLabel.textColor = TimerColor.accent
        } else {
            escalationLabel.text = "đang chạy · Live"
            escalationPillView.backgroundColor = UIColor(hex: "#183629")
            escalationPillView.layer.borderColor = UIColor(hex: "#2E5A46").cgColor
            escalationLabel.textColor = TimerColor.textSecondary
        }
    }

    private func updateProgress(ratio: CGFloat) {
        let clampedRatio = min(max(ratio, 0), 1)
        progressFillView.snp.remakeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(clampedRatio)
        }
    }

    private func flashBorder(color: UIColor) {
        UIView.animate(withDuration: 0.3, animations: {
            self.layer.borderColor = color.cgColor
            self.layer.shadowColor = color.cgColor
            self.layer.shadowOpacity = 0.6
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                self.layer.borderColor = TimerColor.accent.cgColor
                self.layer.shadowColor = TimerColor.accent.cgColor
                self.layer.shadowOpacity = 0.18
            }
        }
    }

    private func triggerHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }

    private func startPulseAnimation() {
        livePulseView.transform = .identity
        livePulseView.alpha = 0.6
        UIView.animate(withDuration: 1.5, delay: 0, options: [.repeat, .autoreverse, .curveEaseInOut], animations: {
            self.livePulseView.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            self.livePulseView.alpha = 0.1
        }, completion: nil)
    }

    private func parseTime(_ timeString: String) -> Int? {
        let parts = timeString.split(separator: ":").compactMap { Int($0) }
        if parts.count == 3 {
            return parts[0] * 3600 + parts[1] * 60 + parts[2]
        } else if parts.count == 2 {
            return parts[0] * 60 + parts[1]
        }
        return nil
    }
}
