<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Faculty Login | Timetable Pro</title>
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
            rel="stylesheet" />
        <link href="https://fonts.googleapis.com/css2?family=Georgia&display=swap" rel="stylesheet" />
        <script>
            tailwind.config = {
                theme: {
                    extend: {
                        colors: {
                            "primary": "#2D5A27",
                            "primary-dark": "#1e3e1a",
                            "background-light": "#F4F1EA",
                        },
                        fontFamily: {
                            "display": ["Inter", "sans-serif"],
                            "serif": ["Georgia", "serif"]
                        }
                    }
                }
            }
        </script>
    </head>

    <body class="bg-background-light font-display min-h-screen flex items-center justify-center p-6">

        <div class="w-full max-w-md bg-white rounded-2xl shadow-xl border border-primary/10 overflow-hidden">
            <!-- Header Section -->
            <div class="bg-primary/5 px-8 py-8 border-b border-primary/10 text-center">
                <div
                    class="mx-auto size-12 bg-primary rounded-xl flex items-center justify-center text-white shadow-md shadow-primary/20 mb-4">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24"
                        stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                            d="M12 14l9-5-9-5-9 5 9 5z" />
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                            d="M12 14l6.16-3.422a12.083 12.083 0 01.665 6.479A11.952 11.952 0 0012 20.055a11.952 11.952 0 00-6.824-2.998 12.078 12.078 0 01.665-6.479L12 14z" />
                    </svg>
                </div>
                <h1 class="text-2xl font-bold text-gray-900 font-serif">Welcome Back</h1>
                <p class="text-sm text-gray-500 mt-2">Log in to view your personalized timetable</p>
            </div>

            <!-- Form Section -->
            <div class="px-8 py-8">
                <% if (request.getAttribute("error") !=null) { %>
                    <div
                        class="bg-red-50 border border-red-200 text-red-600 px-4 py-3 rounded-xl text-sm mb-6 flex items-center gap-2">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24"
                            stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                        </svg>
                        <%= request.getAttribute("error") %>
                    </div>
                    <% } %>

                        <form action="${pageContext.request.contextPath}/faculty_login" method="POST" class="space-y-6">
                            <div>
                                <label for="email" class="block text-sm font-semibold text-gray-700 mb-1.5">Email
                                    Address</label>
                                <input type="email" id="email" name="email" required
                                    class="w-full px-4 py-3 rounded-xl border border-gray-200 focus:border-primary focus:ring-2 focus:ring-primary/20 transition-all text-sm outline-none placeholder-gray-400 object-cover"
                                    placeholder="john.doe@college.edu" />
                            </div>

                            <div class="pt-2">
                                <button type="submit"
                                    class="w-full bg-primary hover:bg-primary-dark text-white font-bold py-3.5 px-4 rounded-xl shadow-lg shadow-primary/20 transition-all font-display">
                                    Sign In as Faculty
                                </button>
                            </div>
                        </form>

                        <div class="mt-8 text-center text-sm text-gray-500">
                            Are you an Administrator? <a href="${pageContext.request.contextPath}/admin"
                                class="text-primary font-semibold hover:underline">Go to Admin Login</a>
                        </div>
                        <div class="mt-2 text-center text-sm text-gray-500">
                            Need to view full timetable? <a href="${pageContext.request.contextPath}/student"
                                class="text-primary font-semibold hover:underline">Go to Student Portal</a>
                        </div>
            </div>
        </div>
    </body>

    </html>