<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="utf-8" />
<meta content="width=device-width, initial-scale=1.0" name="viewport" />
<title>Welcome to Timetable Pro</title>
<script
	src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link
	href="https://fonts.googleapis.com/css2?family=Lexend:wght@300;400;500;600;700;800;900&display=swap"
	rel="stylesheet" />
<link
	href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
	rel="stylesheet" />
<script id="tailwind-config">
            tailwind.config = {
                theme: {
                    extend: {
                        colors: {
                            "primary": "#2D5A27",
                            "primary-dark": "#1e3e1a",
                            "background": "#F4F1EA",
                            "surface": "#FFFFFF",
                            "surface-alt": "#FCFBF9",
                            "text-main": "#1F2937",
                            "text-muted": "#4B5563",
                        },
                        fontFamily: {
                            "display": ["Lexend", "sans-serif"]
                        },
                        borderRadius: {
                            "DEFAULT": "0.5rem",
                            "lg": "1rem",
                            "xl": "1.5rem",
                            "full": "9999px"
                        },
                    },
                },
            }
        </script>
<style>
.material-symbols-outlined {
	font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
}
</style>
</head>

<body
	class="bg-background font-display text-text-main antialiased selection:bg-primary/20 selection:text-primary">
	<div
		class="relative flex min-h-screen w-full flex-col overflow-x-hidden">
		<header
			class="flex items-center justify-between border-b border-primary/10 px-6 py-4 md:px-20 lg:px-40 bg-background/80 backdrop-blur-md sticky top-0 z-50">
			<div class="flex items-center gap-3">
				<div
					class="size-8 bg-primary rounded-lg flex items-center justify-center text-white shadow-md shadow-primary/20">
					<span class="material-symbols-outlined text-2xl">calendar_month</span>
				</div>
				<h2 class="text-xl font-bold tracking-tight text-primary-dark">Timetable
					Pro</h2>
			</div>
			<nav class="hidden md:flex items-center gap-10">
				<a
					class="text-sm font-medium text-text-muted hover:text-primary transition-colors"
					href="admin">Admin</a> <a
					class="text-sm font-medium text-text-muted hover:text-primary transition-colors"
					href="faculty">Faculty</a> <a
					class="text-sm font-medium text-text-muted hover:text-primary transition-colors"
					href="student">Student</a>
			</nav>
			<div class="flex items-center gap-4">
				<a
					class="hidden sm:block text-sm font-semibold px-4 py-2 text-primary-dark hover:text-primary transition-colors"
					href="admin">Log In</a> <a
					class="flex items-center justify-center rounded-xl bg-primary px-6 py-2.5 text-sm font-bold text-white shadow-lg shadow-primary/20 transition-all hover:bg-primary-dark hover:shadow-primary/30 active:scale-95"
					href="student"> Get Started </a>
			</div>
		</header>
		<main class="flex-1">
			<section
				class="mx-auto max-w-[1280px] px-6 py-16 md:px-20 lg:px-40 lg:py-24">
				<div class="grid grid-cols-1 items-center gap-12 lg:grid-cols-2">
					<div class="flex flex-col gap-8 text-left">
						<div
							class="inline-flex items-center gap-2 rounded-full bg-white px-3 py-1 text-xs font-bold uppercase tracking-wider text-primary border border-primary/10 shadow-sm self-start">
							<span class="size-2 rounded-full bg-primary animate-pulse"></span>
							New: AI Scheduling Engine 2.0
						</div>
						<div class="flex flex-col gap-4">
							<h1
								class="text-5xl font-extrabold leading-[1.1] tracking-tight text-primary-dark md:text-6xl lg:text-7xl">
								Automate Your <span class="text-primary relative inline-block">
									College Scheduling <svg
										class="absolute w-full h-3 -bottom-1 left-0 text-primary/20"
										fill="none" viewBox="0 0 200 9"
										xmlns="http://www.w3.org/2000/svg">
                                            <path
											d="M2.00025 6.99997C2.00025 6.99997 64.915 2.15582 119.502 2.99999C155.672 3.5594 198 8.49997 198 8.49997"
											stroke="currentColor" stroke-linecap="round" stroke-width="3"></path>
                                        </svg>
								</span>
							</h1>
							<p class="max-w-[540px] text-lg leading-relaxed text-text-muted">
								Save time and avoid conflicts with our intelligent timetable
								generator designed specifically for students and administrators.
								Organize your academic life in seconds.</p>
						</div>
						<div class="flex flex-wrap gap-4">
							<a href="admin"
								class="flex h-14 min-w-[180px] items-center justify-center rounded-xl bg-primary px-8 text-base font-bold text-white shadow-xl shadow-primary/20 transition-all hover:scale-[1.02] hover:bg-primary-dark hover:shadow-primary/30">
								Get Started Free </a> <a href="#features"
								class="flex h-14 min-w-[180px] items-center justify-center rounded-xl border border-primary/20 bg-white px-8 text-base font-bold text-primary-dark shadow-sm transition-all hover:bg-surface-alt hover:border-primary/40">
								View Features </a>
						</div>
						<div class="flex items-center gap-4 pt-4">
							<div class="flex -space-x-3">
								<div
									class="size-10 rounded-full border-2 border-background bg-slate-200 flex items-center justify-center overflow-hidden shadow-sm">
									<img alt="User" class="size-full object-cover"
										src="https://lh3.googleusercontent.com/aida-public/AB6AXuCTyFmeaY9dR76YCsqTpvBUhWh_rcL8rj0YrQCKvlUr6CEmts953t-YWRA-2sf5CCG1EMOUNEXxZ6DW71misDEWEmC8f7abN0IeIO4xRUzmG3k_Spw17L-kTHbKsLyqk3zuf9SQ1W0OIVTvi_bavl0RNlfzfrJY4kcQBx_llsop_liPyHgs-s8mrir0YSggr5Xcl6hPk-lzZdpeh7UYfnXTkSW9xrTOaKRMcQmk0as5gLr5ld1FNxIGtPiosH8sXSXUcNGO58hk8qo" />
								</div>
								<div
									class="size-10 rounded-full border-2 border-background bg-slate-300 flex items-center justify-center overflow-hidden shadow-sm">
									<img alt="User" class="size-full object-cover"
										src="https://lh3.googleusercontent.com/aida-public/AB6AXuBLOU1wtlDIT-KAqnIU6tKaBLF7C3qZ82S7Od0v8pIpl29ajS8tcRo7AQe8ij37Md8cqnjTxOZ_amRWxwWCa-1Omz4rBxYWnU7DK3xp-E0F0Zr1uuRDe2f1KPEgOA16_KAVNqCaRIUOrp9carp7t3hh9VdR6mpeNZuzI9u90mfrANqgpe08XCccNIzuRNRfUZ6tSsYPRghOLG6TwTOFN1WyLS7GGMcJgfMIQhHg3w011bp76ZC_0tXqIY8RkwkmcQyODv4Utwu3WW8" />
								</div>
								<div
									class="size-10 rounded-full border-2 border-background bg-slate-400 flex items-center justify-center overflow-hidden shadow-sm">
									<img alt="User" class="size-full object-cover"
										src="https://lh3.googleusercontent.com/aida-public/AB6AXuAIoh0Cq6fEY_qEsPGi10A25VBX4xZMS_d0S2ano_Y-DhOtipiG1QB3h_3990XIYO7KAUa5NIUox8rD9OcVCA0ZMxk41M3TS0WFOnz-FHhXUOyHmHkeL4Y5xa2MHflel3HoZKaZfGdyEapDwy3g098_L3qHBKHb50h3qLD5rHzNwefe67h4dB5vJy3MI1Mw-5zePtIc6I9OqzlM9XF-n3n_Q2uKFCNS9iqh6CHO7NNFNSYCNaxvn5Zn46h8hUXU7Aj36me_woix8PU" />
								</div>
							</div>
							<p class="text-sm font-medium text-text-muted">
								<span class="font-bold text-primary-dark">2,000+</span> students
								joined this week
							</p>
						</div>
					</div>
					<div class="relative group mt-8 lg:mt-0">
						<div
							class="absolute -inset-4 rounded-3xl bg-primary/20 blur-2xl transition-all group-hover:bg-primary/30 opacity-70">
						</div>
						<div
							class="relative overflow-hidden rounded-2xl border border-primary/10 bg-white shadow-2xl shadow-primary/10">
							<img alt="App Preview" class="w-full object-cover"
								src="https://lh3.googleusercontent.com/aida-public/AB6AXuAF2lXh2pgpYWF5PCjtQgE-bkXaoPtVOBZM84aF-i2gar64PvT2vuA0WkoJFU0ugoHCs8DQpLef90j-QTx_BLxCwIGL6xHoFGM1r_Q_WsrNEdBfd-nPOxPET6QBQ9jI6RcL9eHXyNA48D9EODhaNOLZPMEl_vvZiSVdm1fuDvpLB9Ubg11FzC604eeL2m2MsI3Dcg3bfust0S2Lzee-RFdopFzigTAma3vSKymN13A0gRMzgVocffrP1_8ErbdjuGXXhMmpCI8nl50" />
						</div>
					</div>
				</div>
			</section>
			<section id="features"
				class="bg-white/50 py-20 border-y border-primary/5">
				<div class="mx-auto max-w-[1280px] px-6 md:px-20 lg:px-40">
					<div class="mb-16 flex flex-col items-center text-center">
						<h2
							class="text-3xl font-bold tracking-tight text-primary-dark sm:text-4xl">Why
							Timetable Pro?</h2>
						<p class="mt-4 max-w-2xl text-text-muted">Everything you need
							to manage a hectic course load without breaking a sweat.</p>
					</div>
					<div class="grid grid-cols-1 gap-8 sm:grid-cols-2 lg:grid-cols-3">
						<div
							class="group flex flex-col gap-4 rounded-2xl border border-primary/10 bg-white p-8 shadow-lg shadow-primary/5 transition-all hover:-translate-y-1 hover:border-primary/30 hover:shadow-xl hover:shadow-primary/10">
							<div
								class="flex size-14 items-center justify-center rounded-xl bg-primary/10 text-primary transition-colors group-hover:bg-primary group-hover:text-white">
								<span class="material-symbols-outlined text-3xl">check_circle</span>
							</div>
							<h3 class="text-xl font-bold text-primary-dark">Conflict-Free</h3>
							<p class="text-text-muted">Our algorithm automatically scans
								thousands of combinations to find the perfect schedule for you.</p>
						</div>
						<div
							class="group flex flex-col gap-4 rounded-2xl border border-primary/10 bg-white p-8 shadow-lg shadow-primary/5 transition-all hover:-translate-y-1 hover:border-primary/30 hover:shadow-xl hover:shadow-primary/10">
							<div
								class="flex size-14 items-center justify-center rounded-xl bg-primary/10 text-primary transition-colors group-hover:bg-primary group-hover:text-white">
								<span class="material-symbols-outlined text-3xl">sync</span>
							</div>
							<h3 class="text-xl font-bold text-primary-dark">Auto-Sync</h3>
							<p class="text-text-muted">Export your generated timetable
								directly to Google Calendar, Apple Calendar, or Outlook with one
								click.</p>
						</div>
						<div
							class="group flex flex-col gap-4 rounded-2xl border border-primary/10 bg-white p-8 shadow-lg shadow-primary/5 transition-all hover:-translate-y-1 hover:border-primary/30 hover:shadow-xl hover:shadow-primary/10">
							<div
								class="flex size-14 items-center justify-center rounded-xl bg-primary/10 text-primary transition-colors group-hover:bg-primary group-hover:text-white">
								<span class="material-symbols-outlined text-3xl">notifications_active</span>
							</div>
							<h3 class="text-xl font-bold text-primary-dark">Smart Alerts</h3>
							<p class="text-text-muted">Receive real-time notifications
								about room changes, professor updates, or schedule
								cancellations.</p>
						</div>
					</div>
				</div>
			</section>
			<section class="mx-auto max-w-[1280px] px-6 py-24 md:px-20 lg:px-40">
				<div
					class="relative overflow-hidden rounded-3xl bg-primary px-8 py-16 text-center text-white shadow-2xl shadow-primary/30">
					<div
						class="absolute right-0 top-0 -mr-20 -mt-20 size-64 rounded-full bg-white/10 blur-3xl">
					</div>
					<div
						class="absolute bottom-0 left-0 -ml-20 -mb-20 size-64 rounded-full bg-black/10 blur-3xl">
					</div>
					<div class="absolute inset-0 opacity-10"
						style="background-image: radial-gradient(circle at 2px 2px, white 1px, transparent 0); background-size: 32px 32px;">
					</div>
					<div class="relative z-10 flex flex-col items-center gap-8">
						<h2
							class="max-w-2xl text-3xl font-bold tracking-tight sm:text-5xl">Ready
							to organize your semester?</h2>
						<p class="max-w-xl text-lg text-white/90">Join thousands of
							students and faculty members who have simplified their schedules.</p>
						<a href="admin"
							class="flex h-14 min-w-[220px] items-center justify-center rounded-xl bg-white px-10 text-lg font-bold text-primary shadow-xl transition-all hover:scale-105 hover:shadow-2xl active:scale-95">
							Get Started Now </a>
					</div>
				</div>
			</section>
		</main>
		<footer class="border-t border-primary/10 bg-white/40 py-12">
			<div class="mx-auto max-w-[1280px] px-6 md:px-20 lg:px-40">
				<div
					class="flex flex-col items-center justify-between gap-8 md:flex-row">
					<div class="flex items-center gap-3">
						<div
							class="size-6 bg-primary rounded flex items-center justify-center text-white shadow-sm">
							<span class="material-symbols-outlined text-sm">calendar_month</span>
						</div>
						<span class="text-lg font-bold text-primary-dark">Timetable
							Pro</span>
					</div>
					<div
						class="flex flex-wrap justify-center gap-8 text-sm font-medium text-text-muted">
						<a class="hover:text-primary transition-colors" href="#">Privacy
							Policy</a> <a class="hover:text-primary transition-colors" href="#">Terms
							of Service</a> <a class="hover:text-primary transition-colors"
							href="#">Help Center</a> <a
							class="hover:text-primary transition-colors" href="#">Contact</a>
					</div>
					<div class="flex items-center gap-4">
						<a
							class="text-text-muted hover:text-primary transition-colors hover:scale-110 transform"
							href="#"> <span class="material-symbols-outlined">alternate_email</span>
						</a> <a
							class="text-text-muted hover:text-primary transition-colors hover:scale-110 transform"
							href="#"> <span class="material-symbols-outlined">public</span>
						</a> <a
							class="text-text-muted hover:text-primary transition-colors hover:scale-110 transform"
							href="#"> <span class="material-symbols-outlined">share</span>
						</a>
					</div>
				</div>
				<div class="mt-8 text-center text-xs text-text-muted/70">©
					2024 Timetable Pro. All academic rights reserved.</div>
			</div>
		</footer>
	</div>
</body>

</html>