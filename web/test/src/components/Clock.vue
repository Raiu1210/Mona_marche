<script>
const zeroPadding = (num, digit) => {
    return (Array(digit).join("0") + num).slice(-digit)
}


export default {
    data() {
        return {
            date: new Date(),
        }
    },
    computed: {
        year() {
            return this.date.getFullYear()
        },
        month() {
            return zeroPadding(this.date.getMonth + 1, 2)
        },
        day() {
            return zeroPadding(this.date.getDate(), 2)
        },
        hours() {
            return zeroPadding(this.date.getHours(), 2)
        },
        minutes() {
            return zeroPadding(this.date.getMinutes(), 2)
        },
        seconds() {
            return zeroPadding(this.date.getSeconds(), 2)
        },
    },
    mounted() {
        this.setDate()
        setInterval(() => this.setDate(), 1000)
    },
    methods: {
        setDate() {
            this.date = new Date()
        },
    },
}
</script>
